import 'dart:async';

import 'package:web/web.dart' as web;

/// The overlay's hooks in the shared shell's `web/index.html` and `css/loading_animation.css`.
const String _loadingSelector = '.loading';
const String _backgroundId = 'background-animation';
const String _fadeOutClass = 'fade-out';

/// The CSS transition's length; the elements go once it has run.
const Duration _fadeOut = Duration(milliseconds: 500);

void dismissBootOverlayImpl() {
  final List<web.Element> overlay = <web.Element>[
    ?web.document.querySelector(_loadingSelector),
    ?web.document.getElementById(_backgroundId),
  ];
  for (final web.Element element in overlay) {
    element.classList.add(_fadeOutClass);
  }
  Timer(_fadeOut, () {
    for (final web.Element element in overlay) {
      element.remove();
    }
  });
}
