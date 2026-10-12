// The 404 page's picture is an asset path in code: a rename that misses it shows a broken image only on that page.
@TestOn('vm')
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Pages/ErrorPage/error_page_widget.dart';

void main() {
  testWidgets('the 404 animation exists and decodes, all 100 frames', (
    WidgetTester tester,
  ) async {
    final File file = File(
      ErrorPageWidget.imageAsset.replaceFirst('packages/anthology/', ''),
    );
    expect(file.existsSync(), isTrue, reason: file.path);
    await tester.runAsync(() async {
      final ui.Codec codec = await ui.instantiateImageCodec(
        file.readAsBytesSync(),
      );
      expect(codec.frameCount, 100);
      final ui.FrameInfo frame = await codec.getNextFrame();
      expect((frame.image.width, frame.image.height), (800, 600));
      expect(frame.duration, const Duration(milliseconds: 40));
      frame.image.dispose();
      codec.dispose();
    });
  });
}
