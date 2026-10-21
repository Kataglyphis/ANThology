// The shell's overlay is plain HTML, so only a browser run has one to remove.
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:web/web.dart' as web;

import 'package:anthology/Boot/boot_overlay.dart';

void main() {
  test('fades the overlay out, then removes it', () async {
    final web.HTMLDivElement loading = web.HTMLDivElement()
      ..className = 'loading';
    final web.HTMLDivElement background = web.HTMLDivElement()
      ..id = 'background-animation';
    web.document.body!
      ..append(background)
      ..append(loading);

    dismissBootOverlay();
    expect(loading.classList.contains('fade-out'), isTrue);
    expect(background.classList.contains('fade-out'), isTrue);

    await Future<void>.delayed(const Duration(milliseconds: 600));
    expect(web.document.querySelector('.loading'), isNull);
    expect(web.document.getElementById('background-animation'), isNull);
  });

  test('a page without the overlay is left alone', () {
    expect(dismissBootOverlay, returnsNormally);
  });
}
