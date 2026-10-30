/// One turn of a conversation as the chat widgets show it; the family's text contract names the roles.
enum ChatRole { system, user, assistant, tool }

/// Why an answer ended, as the text contract reports it.
enum ChatFinish { stop, length, cancelled }

/// The speed figures of one finished answer.
class ChatFigures {
  const ChatFigures({
    required this.completionTokens,
    required this.timeToFirstTokenMs,
    required this.decodeTokensPerSecond,
    required this.finish,
  });

  final int completionTokens;
  final double timeToFirstTokenMs;
  final double decodeTokensPerSecond;
  final ChatFinish finish;
}

/// A message in the list; `streaming` while its text still grows.
class ChatEntry {
  const ChatEntry({
    required this.role,
    required this.text,
    this.streaming = false,
    this.figures,
  });

  final ChatRole role;
  final String text;
  final bool streaming;
  final ChatFigures? figures;

  /// The same message with more text, a finished state or its figures.
  ChatEntry copyWith({String? text, bool? streaming, ChatFigures? figures}) =>
      ChatEntry(
        role: role,
        text: text ?? this.text,
        streaming: streaming ?? this.streaming,
        figures: figures ?? this.figures,
      );
}
