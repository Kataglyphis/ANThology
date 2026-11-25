import 'package:anthology/material_compatibility.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:material_ui/material_ui.dart';

const _markdown =
    'See [the docs](https://example.invalid) and ![logo](assets/images/logo.png).';

Widget _app({required bool dark, required MarkdownConfig config}) =>
    MaterialApp(
      theme: ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
      localizationsDelegates: anthologyLocalizationsDelegates,
      builder: anthologyMaterialBuilder,
      home: Scaffold(
        body: MarkdownBlock(data: _markdown, config: config),
      ),
    );

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'markdown with a link and an image renders and opens under material_ui (dark: $dark)',
      (tester) async {
        await tester.pumpWidget(
          _app(
            dark: dark,
            config: anthologyMarkdownConfig(dark: dark),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        // The asset decodes asynchronously, so a hit test may find a zero-sized image; the tap itself is what must not throw.
        tester.widget<InkWell>(find.byType(InkWell).first).onTap!();
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(ImageViewer), findsOneWidget);
      },
    );
  }

  testWidgets(
    "markdown_widget's own image InkWell still needs flutter/material, which is why the config replaces it",
    (tester) async {
      await tester.pumpWidget(
        _app(dark: false, config: MarkdownConfig.defaultConfig),
      );
      await tester.pump();
      expect(tester.takeException(), isNotNull);
    },
  );
}
