import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:anthology/Widgets/Chat/chat_entry.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// The conversation, newest at the bottom; answers render as Markdown and keep the end in view while they grow.
class ChatMessageList extends StatefulWidget {
  const ChatMessageList({super.key, required this.messages, this.controller});

  final List<ChatEntry> messages;

  /// Scrolls the list; one is made when none is given.
  final ScrollController? controller;

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  ScrollController? _own;

  ScrollController get _controller =>
      widget.controller ?? (_own ??= ScrollController());

  @override
  void didUpdateWidget(ChatMessageList oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _followTheEnd());
  }

  void _followTheEnd() {
    if (!mounted || !_controller.hasClients) return;
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shown = widget.messages
        .where((m) => m.role != ChatRole.system)
        .toList(growable: false);
    return ListView.builder(
      controller: _controller,
      padding: const EdgeInsets.all(12),
      itemCount: shown.length,
      itemBuilder: (context, index) => ChatBubble(entry: shown[index]),
    );
  }
}

/// One message: the user's on the right as plain text, every other on the left as Markdown.
class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.entry});

  final ChatEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mine = entry.role == ChatRole.user;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final markdown = dark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    final body = mine
        ? SelectableText(entry.text)
        : MarkdownBlock(data: entry.text, config: markdown);
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Card(
          color: mine ? scheme.primaryContainer : scheme.surfaceContainerHigh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                body,
                if (entry.streaming)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: SizedBox(
                      width: 48,
                      child: LinearProgressIndicator(),
                    ),
                  ),
                if (entry.figures != null)
                  ChatFiguresLine(figures: entry.figures!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The figures under a finished answer, and why it ended when that was not its own stop.
class ChatFiguresLine extends StatelessWidget {
  const ChatFiguresLine({super.key, required this.figures});

  final ChatFigures figures;

  @override
  Widget build(BuildContext context) {
    final l10n = AnthologyLocalizations.of(context)!;
    final parts = [
      l10n.chatFigures(
        figures.completionTokens,
        figures.timeToFirstTokenMs.toStringAsFixed(0),
        figures.decodeTokensPerSecond.toStringAsFixed(1),
      ),
      if (figures.finish == ChatFinish.cancelled) l10n.chatStopped,
      if (figures.finish == ChatFinish.length) l10n.chatTruncated,
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Text(
        parts.join(' · '),
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
