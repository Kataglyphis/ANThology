import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Media/Image/openable_image.dart';

void main() {
  test('the fade-in starts from a transparent pixel, not a downloaded photo', () {
    // The default used to be a 766 kB cat photo, fetched on every page with an image.
    final FadeInImage image = OpenableImage(
      displayedImage: 'packages/anthology/assets/images/cat-computer.gif',
    ).ourMainImage;
    expect(image.placeholder, isA<MemoryImage>());
    expect((image.placeholder as MemoryImage).bytes.length, lessThan(100));
  });

  test('a placeholder that is passed is still the asset it names', () {
    final FadeInImage image = OpenableImage(
      displayedImage: 'a.png',
      placeholderImage: 'b.png',
    ).ourMainImage;
    expect(image.placeholder, isA<AssetImage>());
    expect((image.placeholder as AssetImage).assetName, 'b.png');
  });
}
