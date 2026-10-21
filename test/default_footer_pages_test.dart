// The package's own test bundle keys its assets without the packages/anthology/ prefix, so the files are read off disk.
@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Pages/Footer/default_footer_pages.dart';
import 'package:anthology/Pages/Footer/footer_page_config.dart';

const String _prefix = 'packages/anthology/';

void main() {
  test('the seven footer pages, each on its own route', () {
    final List<FooterPageConfig> configs = defaultFooterPageConfigs();
    expect(configs.map((c) => c.getRoutingName()), <String>[
      '/imprint',
      '/contact',
      '/privacyPolicy',
      '/cookieDeclaration',
      '/declarationOnAccessibility',
      '/copyright',
      openSourceLicensesRoute,
    ]);
  });

  test('every legal text is a file this package ships', () {
    for (final FooterPageConfig config in defaultFooterPageConfigs()) {
      if (config.getRoutingName() == openSourceLicensesRoute) continue;
      for (final String path in <String>[
        config.getFilePathDe(),
        config.getFilePathEn(),
      ]) {
        expect(path, startsWith('${_prefix}assets/documents/footer/'));
        final File file = File(path.substring(_prefix.length));
        expect(file.existsSync(), isTrue, reason: path);
        expect(file.lengthSync(), greaterThan(0), reason: path);
      }
    }
  });
}
