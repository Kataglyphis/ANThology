import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:anthology/l10n/anthology_localizations.dart';

/// The message field: Enter sends, Shift+Enter breaks the line; while an answer runs the button stops it.
class ChatInput extends StatefulWidget {
  const ChatInput({
    super.key,
    required this.onSend,
    this.onStop,
    this.busy = false,
  });

  /// Receives the trimmed text; never an empty one.
  final ValueChanged<String> onSend;
  final VoidCallback? onStop;

  /// An answer is being generated: sending waits and the button stops it.
  final bool busy;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _text = TextEditingController();
  late final FocusNode _focus = FocusNode(onKeyEvent: _onKey);

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    final enter =
        event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter;
    if (event is! KeyDownEvent ||
        !enter ||
        HardwareKeyboard.instance.isShiftPressed) {
      return KeyEventResult.ignored;
    }
    _send();
    return KeyEventResult.handled;
  }

  void _send() {
    final text = _text.text.trim();
    if (widget.busy || text.isEmpty) return;
    widget.onSend(text);
    _text.clear();
  }

  @override
  void dispose() {
    _text.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AnthologyLocalizations.of(context)!;
    final button = widget.busy
        ? IconButton(
            tooltip: l10n.chatStop,
            icon: const Icon(Icons.stop_circle_outlined),
            onPressed: widget.onStop,
          )
        : ValueListenableBuilder<TextEditingValue>(
            valueListenable: _text,
            builder: (context, value, _) => IconButton(
              tooltip: l10n.chatSend,
              icon: const Icon(Icons.send),
              onPressed: value.text.trim().isEmpty ? null : _send,
            ),
          );
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _text,
              focusNode: _focus,
              minLines: 1,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: l10n.chatInputHint,
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          button,
        ],
      ),
    );
  }
}
