import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Licenses/bundled_licenses.dart';

/// A bundle that serves one text and records which keys were asked for.
class _TextBundle extends CachingAssetBundle {
  _TextBundle(this.text);

  final String text;
  final List<String> asked = <String>[];

  @override
  Future<ByteData> load(String key) async {
    asked.add(key);
    return ByteData.sublistView(Uint8List.fromList(text.codeUnits));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    LicenseRegistry.reset();
    resetAnthologyLicenseRegistration();
  });

  test('assetLicense names the packages and carries the asset text', () async {
    final _TextBundle bundle = _TextBundle('licence text');
    final List<LicenseEntry> entries = await assetLicense(bundle, <String>[
      'Some Font',
    ], 'packages/x/LICENSE').toList();
    expect(entries, hasLength(1));
    expect(entries.single.packages, <String>['Some Font']);
    expect(entries.single.paragraphs.single.text, 'licence text');
    expect(bundle.asked, <String>['packages/x/LICENSE']);
  });

  test('registerAnthologyLicenses adds Roboto once, from its asset', () async {
    final _TextBundle bundle = _TextBundle('Apache License');
    registerAnthologyLicenses(bundle: bundle);
    registerAnthologyLicenses(bundle: bundle);
    final List<LicenseEntry> roboto = await LicenseRegistry.licenses
        .where((LicenseEntry e) => e.packages.contains('Roboto'))
        .toList()
        .timeout(const Duration(seconds: 10));
    expect(roboto, hasLength(1));
    expect(bundle.asked, <String>[robotoLicenseAsset]);
  });

  test(
    'the Roboto notice is declared in pubspec.yaml and is the Apache-2.0 text',
    () {
      const String path = 'assets/fonts/Roboto/LICENSE.txt';
      expect(robotoLicenseAsset, 'packages/anthology/$path');
      expect(File('pubspec.yaml').readAsStringSync(), contains('- $path'));
      final String text = File(path).readAsStringSync();
      expect(text, contains('Apache License'));
      expect(text, contains('Version 2.0, January 2004'));
    },
    // Reads the checkout; a browser test serves no files.
    testOn: 'vm',
  );
}
