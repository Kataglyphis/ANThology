import 'package:anthology/l10n/anthology_localizations.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:material_ui/material_ui.dart';

/// ANThology's catalogue and material_ui's framework delegates, for every MaterialApp an ANThology host builds.
const List<LocalizationsDelegate<dynamic>> anthologyLocalizationsDelegates = [
  AnthologyLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

/// A MaterialApp.builder that gives packages still on flutter/material this app's theme and localizations.
Widget anthologyMaterialBuilder(BuildContext context, Widget? child) =>
    // The official bridge is deprecated as temporary: drop it once markdown_widget and fl_chart import material_ui.
    // ignore: deprecated_member_use
    MaterialUiCompatibilityBridge(child: child ?? const SizedBox.shrink());

/// Markdown in this app's theme; images tap through material_ui, since markdown_widget's own InkWell needs flutter/material's Material.
MarkdownConfig anthologyMarkdownConfig({
  required bool dark,
  List<WidgetConfig> configs = const [],
}) => (dark ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig).copy(
  configs: [
    ...configs,
    const ImgConfig(builder: _markdownImage),
  ],
);

Widget _markdownImage(String url, Map<String, String> attributes) {
  final width = double.tryParse(attributes['width'] ?? '');
  final height = double.tryParse(attributes['height'] ?? '');
  final image = url.startsWith('http')
      ? Image.network(url, width: width, height: height, fit: BoxFit.cover)
      : Image.asset(url, width: width, height: height, fit: BoxFit.cover);
  return Builder(
    builder: (context) => InkWell(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder<void>(
          opaque: false,
          pageBuilder: (_, _, _) => ImageViewer(child: image),
        ),
      ),
      child: Hero(tag: image.hashCode, child: image),
    ),
  );
}
