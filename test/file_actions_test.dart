import 'package:anthology/Media/Download/download_button.dart';
import 'package:anthology/Media/Files/file_actions.dart';
import 'package:anthology/Media/Open/open_button.dart';
import 'package:anthology/l10n/anthology_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Actions implements FileActions {
  final opened = <String>[];
  final saved = <String>[];
  bool fail = false;

  @override
  Future<void> open(String asset) async {
    if (fail) throw StateError('No file association');
    opened.add(asset);
  }

  @override
  Future<void> save(String asset) async {
    if (fail) throw StateError('The save dialog failed');
    saved.add(asset);
  }
}

Future<void> _mount(WidgetTester tester, FileActions actions) =>
    tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AnthologyLocalizations.localizationsDelegates,
        supportedLocales: AnthologyLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              OpenButton(
                assetFullPath: 'packages/anthology/example.pdf',
                fileActions: actions,
              ),
              DownloadButton(
                assetFullPath: 'assets/example.zip',
                fileActions: actions,
              ),
            ],
          ),
        ),
      ),
    );

void main() {
  testWidgets('file buttons send exact bundle keys to the platform service', (
    tester,
  ) async {
    final actions = _Actions();
    await _mount(tester, actions);
    await tester.tap(find.byType(ElevatedButton));
    await tester.tap(find.byIcon(Icons.file_download));
    await tester.pump();
    expect(actions.opened, ['packages/anthology/example.pdf']);
    expect(actions.saved, ['assets/example.zip']);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'native action failures show feedback without an uncaught callback error',
    (tester) async {
      await _mount(tester, _Actions()..fail = true);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Could not open or save this file.'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 5));
    },
  );
}
