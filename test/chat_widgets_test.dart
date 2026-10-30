import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Widgets/Chat/chat_panel.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

Widget _app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AnthologyLocalizations.localizationsDelegates,
  supportedLocales: AnthologyLocalizations.supportedLocales,
  home: Scaffold(body: child),
);

const _figures = ChatFigures(
  completionTokens: 8,
  timeToFirstTokenMs: 41.6,
  decodeTokensPerSecond: 197.24,
  finish: ChatFinish.stop,
);

void main() {
  testWidgets('answers render as Markdown and questions as plain text', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const ChatMessageList(
          messages: [
            ChatEntry(role: ChatRole.system, text: 'hidden system prompt'),
            ChatEntry(role: ChatRole.user, text: 'What is **bold**?'),
            ChatEntry(
              role: ChatRole.assistant,
              text: 'It is **this**.',
              figures: _figures,
            ),
          ],
        ),
      ),
    );
    expect(find.text('hidden system prompt'), findsNothing);
    expect(find.text('What is **bold**?'), findsOneWidget);
    expect(
      find.textContaining('**this**', findRichText: true),
      findsNothing,
      reason: 'the Markdown is rendered, not shown',
    );
    expect(
      find.textContaining('It is this.', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text('8 tokens · 42 ms to the first · 197.2 tokens/s'),
      findsOneWidget,
    );
  });

  testWidgets('a streaming answer shows progress and no figures yet', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const ChatMessageList(
          messages: [
            ChatEntry(
              role: ChatRole.assistant,
              text: 'The capital',
              streaming: true,
            ),
          ],
        ),
      ),
    );
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.textContaining('tokens/s'), findsNothing);
  });

  testWidgets('a stopped or cut-off answer says so, in the app locale', (
    tester,
  ) async {
    final stopped = ChatFigures(
      completionTokens: 1,
      timeToFirstTokenMs: 1,
      decodeTokensPerSecond: 0,
      finish: ChatFinish.cancelled,
    );
    await tester.pumpWidget(
      _app(
        ChatMessageList(
          messages: [
            ChatEntry(role: ChatRole.assistant, text: 'a', figures: stopped),
            const ChatEntry(
              role: ChatRole.assistant,
              text: 'b',
              figures: ChatFigures(
                completionTokens: 2,
                timeToFirstTokenMs: 1,
                decodeTokensPerSecond: 1,
                finish: ChatFinish.length,
              ),
            ),
          ],
        ),
        locale: const Locale('de'),
      ),
    );
    expect(find.textContaining('Abgebrochen'), findsOneWidget);
    expect(find.textContaining('Am Token-Limit abgeschnitten'), findsOneWidget);
  });

  testWidgets('send passes the trimmed text once and clears the field', (
    tester,
  ) async {
    final sent = <String>[];
    await tester.pumpWidget(_app(ChatInput(onSend: sent.add)));
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNull,
      reason: 'nothing to send yet',
    );
    await tester.enterText(find.byType(TextField), '  Hallo  ');
    await tester.pump();
    await tester.tap(find.byTooltip('Send'));
    await tester.pump();
    expect(sent, ['Hallo']);
    expect(find.text('  Hallo  '), findsNothing);
  });

  testWidgets('Enter sends and Shift+Enter does not', (tester) async {
    final sent = <String>[];
    await tester.pumpWidget(_app(ChatInput(onSend: sent.add)));
    await tester.enterText(find.byType(TextField), 'first');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    expect(sent, isEmpty);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(sent, ['first']);
  });

  testWidgets('while busy the button stops and sending waits', (tester) async {
    final sent = <String>[];
    var stops = 0;
    await tester.pumpWidget(
      _app(ChatInput(onSend: sent.add, onStop: () => stops++, busy: true)),
    );
    await tester.enterText(find.byType(TextField), 'next');
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.tap(find.byTooltip('Stop'));
    expect(sent, isEmpty);
    expect(stops, 1);
  });

  testWidgets('the panel follows the end of a growing conversation', (
    tester,
  ) async {
    List<ChatEntry> turns(int n) => [
      for (var i = 0; i < n; i++)
        ChatEntry(
          role: i.isEven ? ChatRole.user : ChatRole.assistant,
          text: 'message $i\n\nline two',
        ),
    ];
    await tester.pumpWidget(
      _app(ChatPanel(messages: turns(2), onSend: (_) {})),
    );
    await tester.pumpWidget(
      _app(ChatPanel(messages: turns(40), onSend: (_) {})),
    );
    await tester.pumpAndSettle();
    expect(
      find.textContaining('message 39', findRichText: true),
      findsOneWidget,
    );
  });
}
