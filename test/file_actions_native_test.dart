@TestOn('vm')
library;

import 'dart:io';

import 'package:anthology/Media/Files/file_actions_native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _Bundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = Uint8List.fromList([0, 1, 2, 3, 4]);
    return ByteData.sublistView(bytes, 1, 4);
  }
}

void main() {
  test(
    'native open extracts exact bundled bytes and isolates identical filenames',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'anthology-files-test',
      );
      addTearDown(() => directory.delete(recursive: true));
      final opened = <File>[];
      final actions = NativeFileActions(
        bundle: _Bundle(),
        temporaryDirectory: () async => directory,
        openFile: (file) async => opened.add(file),
      );
      await actions.open('packages/anthology/first/example.pdf');
      await actions.open('assets/second/example.pdf');
      expect(opened, hasLength(2));
      expect(opened[0].path, isNot(opened[1].path));
      expect(await opened[0].readAsBytes(), [1, 2, 3]);
      expect(await opened[1].readAsBytes(), [1, 2, 3]);
      await expectLater(actions.open('../example.pdf'), throwsArgumentError);
    },
  );

  test(
    'native save hands bytes, original filename and MIME type to the save dialog',
    () async {
      (Uint8List, String, String)? saved;
      final actions = NativeFileActions(
        bundle: _Bundle(),
        saveFile: (bytes, name, mime) async => saved = (bytes, name, mime),
      );
      await actions.save('packages/anthology/Example File.pdf');
      expect(saved!.$1, [1, 2, 3]);
      expect(saved!.$2, 'Example File.pdf');
      expect(saved!.$3, 'application/pdf');
    },
  );
}
