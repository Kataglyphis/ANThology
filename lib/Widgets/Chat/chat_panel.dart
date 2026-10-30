import 'package:flutter/material.dart';

import 'package:anthology/Widgets/Chat/chat_entry.dart';
import 'package:anthology/Widgets/Chat/chat_input.dart';
import 'package:anthology/Widgets/Chat/chat_message_list.dart';

export 'package:anthology/Widgets/Chat/chat_entry.dart';
export 'package:anthology/Widgets/Chat/chat_input.dart';
export 'package:anthology/Widgets/Chat/chat_message_list.dart';

/// The conversation above its input; the caller owns the messages and the backend.
class ChatPanel extends StatelessWidget {
  const ChatPanel({
    super.key,
    required this.messages,
    required this.onSend,
    this.onStop,
    this.busy = false,
  });

  final List<ChatEntry> messages;
  final ValueChanged<String> onSend;
  final VoidCallback? onStop;
  final bool busy;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(child: ChatMessageList(messages: messages)),
      const Divider(height: 1),
      ChatInput(onSend: onSend, onStop: onStop, busy: busy),
    ],
  );
}
