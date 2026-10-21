import 'package:flutter/services.dart';

/// Loads this package's Roboto under the family the app shell's themes name, so a widget test measures text as
/// the app does: the test font's square glyphs overflow rows real text fits.
Future<void> loadAnthologyFonts() async {
  const String dir = 'packages/anthology/assets/fonts/Roboto';
  final FontLoader roboto = FontLoader('packages/anthology/Roboto');
  for (final String face in <String>['Regular', 'Medium', 'Bold', 'Italic']) {
    roboto.addFont(rootBundle.load('$dir/Roboto-$face.ttf'));
  }
  await roboto.load();
}
