import 'dart:convert';

import 'package:anthology/Media/Markdown/markdown_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_widget/markdown_widget.dart';

class _Bundle extends CachingAssetBundle {
  final reads = <String>[];

  @override
  Future<ByteData> load(String key) async {
    if (key == 'AssetManifest.bin' || key == 'AssetManifest.bin.json') {
      final manifest = const StandardMessageCodec().encodeMessage(
        <String, Object>{},
      )!;
      if (key.endsWith('.json')) {
        return ByteData.sublistView(
          utf8.encode(
            jsonEncode(
              base64Encode(
                manifest.buffer.asUint8List(
                  manifest.offsetInBytes,
                  manifest.lengthInBytes,
                ),
              ),
            ),
          ),
        );
      }
      return manifest;
    }
    reads.add(key);
    return ByteData.sublistView(
      utf8.encode(key == 'de.md' ? 'Guten Tag' : 'Hello'),
    );
  }
}

void main() {
  testWidgets(
    'a retained Markdown page reloads its selected locale without remounting',
    (tester) async {
      final bundle = _Bundle();
      Widget page(Locale locale, {bool light = false}) => MaterialApp(
        home: SingleChildScrollView(
          child: MarkdownFilePage(
            currentLocale: locale,
            filePathDe: 'de.md',
            filePathEn: 'en.md',
            useLightMode: light,
            assetBundle: bundle,
          ),
        ),
      );
      await tester.pumpWidget(page(const Locale('en')));
      await tester.pumpAndSettle();
      final state = tester.state(find.byType(MarkdownFilePage));
      expect(
        tester.widget<MarkdownWidget>(find.byType(MarkdownWidget)).data,
        'Hello',
      );
      await tester.pumpWidget(page(const Locale('en'), light: true));
      await tester.pumpAndSettle();
      expect(bundle.reads, ['en.md']);
      await tester.pumpWidget(page(const Locale('de', 'AT')));
      await tester.pumpAndSettle();
      expect(tester.state(find.byType(MarkdownFilePage)), same(state));
      expect(
        find.byType(MarkdownWidget),
        findsOneWidget,
        reason: tester
            .widgetList<Text>(find.byType(Text))
            .map((text) => text.data)
            .join('\n'),
      );
      expect(
        tester.widget<MarkdownWidget>(find.byType(MarkdownWidget)).data,
        'Guten Tag',
      );
      expect(bundle.reads, ['en.md', 'de.md']);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
    },
  );
}
