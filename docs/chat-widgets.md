# Chat widgets

`lib/Widgets/Chat/` shows a conversation with a language model and takes the next message. The
widgets hold no backend: the caller owns the messages and streams the answer into them, for example
from OxidANT's `text_generate` through OmniAccelerANT's AI Playground. Import
`package:anthology/Widgets/Chat/chat_panel.dart`, which also exports the parts.

| Widget | What it does |
| --- | --- |
| `ChatPanel(messages, onSend, onStop, busy)` | The list above the input |
| `ChatMessageList(messages)` | The user's messages on the right as plain text, every other role on the left as Markdown; `system` messages are not shown. It follows the end while an answer grows |
| `ChatInput(onSend, onStop, busy)` | Enter sends the trimmed text, Shift+Enter breaks the line, an empty field sends nothing. While `busy` the button stops the answer and Enter sends nothing |
| `ChatFiguresLine(figures)` | The token count, the time to the first token and the decode rate under a finished answer, and whether it was stopped or cut off at its token limit |

`ChatEntry` is one message: its `ChatRole` (`system`, `user`, `assistant`, `tool`, the roles of the
family's text contract), its text, `streaming` while it still grows, and its `ChatFigures` once it
is done. `copyWith` appends a piece or finishes it. The strings come from the `chat*` entries of the
`lib/l10n` catalogues, in English, German and French.

`test/chat_widgets_test.dart` covers the Markdown rendering, the streaming state, the figures in
two locales, sending by button and by Enter, the busy state and following the end.
