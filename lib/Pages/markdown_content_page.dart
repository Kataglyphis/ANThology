import 'package:flutter/material.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Layout/ResponsiveDesign/single_page.dart';
import 'package:anthology/Media/Files/file.dart';
import 'package:anthology/Media/Files/file_table.dart';
import 'package:anthology/Media/Markdown/markdown_page.dart';
import 'package:anthology/app_attributes.dart';

/// Config for a page showing markdown plus an appendix file table; pass it to [MarkdownContentPage].
abstract class MarkdownContentConfig {
  /// The path to the markdown file to display.
  String get filePath;

  /// The directory containing images referenced in the markdown.
  String get imageDir;

  /// Appendix documents, each a map with 'baseDir', 'title' and 'additionalInfo'.
  List<Map<String, String>> get docsDesc;
}

/// Markdown content with an appendix file table, built from a [MarkdownContentConfig].
class MarkdownContentPage extends StatelessWidget {
  /// The application-wide attributes for theming and layout.
  final AppAttributes appAttributes;

  /// The footer widget to display at the bottom of the page.
  final Footer footer;

  /// The title above the appendix file table; defaults to 'Appendix'.
  final String appendixTitle;

  final MarkdownContentConfig? _config;
  final String? _legacyFilePath;
  final String? _legacyImageDir;
  final List<Map<String, String>>? _legacyDocsDesc;

  /// Pass [config] or the deprecated pre-1.2 [filePath]/[imageDir]/[docsDesc] trio, never both.
  /// The analyzer does not flag the deprecated parameters, so only these docs announce the migration.
  const MarkdownContentPage({
    super.key,
    required this.appAttributes,
    required this.footer,
    MarkdownContentConfig? config,
    this.appendixTitle = 'Appendix',
    @Deprecated(
      'Pass a MarkdownContentConfig via `config` instead. '
      'This parameter will be removed in a future release.',
    )
    String? filePath,
    @Deprecated(
      'Pass a MarkdownContentConfig via `config` instead. '
      'This parameter will be removed in a future release.',
    )
    String? imageDir,
    @Deprecated(
      'Pass a MarkdownContentConfig via `config` instead. '
      'This parameter will be removed in a future release.',
    )
    List<Map<String, String>>? docsDesc,
  }) : _config = config,
       _legacyFilePath = filePath,
       _legacyImageDir = imageDir,
       _legacyDocsDesc = docsDesc,
       assert(
         (config != null) !=
             (filePath != null || imageDir != null || docsDesc != null),
         'MarkdownContentPage: pass either `config:` or the deprecated '
         '`filePath:`/`imageDir:`/`docsDesc:` trio - not both, not neither.',
       );

  /// The resolved configuration; throws [StateError], in release builds too, when neither form was supplied.
  MarkdownContentConfig get config {
    final MarkdownContentConfig? explicitConfig = _config;
    if (explicitConfig != null) {
      return explicitConfig;
    }
    final String? filePath = _legacyFilePath;
    final String? imageDir = _legacyImageDir;
    if (filePath == null || imageDir == null) {
      throw StateError(
        'MarkdownContentPage was constructed without a `config:` and without '
        'the deprecated `filePath:`/`imageDir:` pair; it has nothing to render.',
      );
    }
    return _LegacyMarkdownContentConfig(
      filePath: filePath,
      imageDir: imageDir,
      docsDesc: _legacyDocsDesc ?? const <Map<String, String>>[],
    );
  }

  @override
  Widget build(BuildContext context) {
    final MarkdownContentConfig resolvedConfig = config;
    final docs = resolvedConfig.docsDesc
        .map(
          (fileConfig) => File(
            baseDir: fileConfig['baseDir'] ?? '',
            title: fileConfig['title'] ?? '',
            additionalInfo: fileConfig['additionalInfo'] ?? '',
          ),
        )
        .toList();

    return SinglePage(
      footer: footer,
      appAttributes: appAttributes,
      showMediumSizeLayout: appAttributes.showMediumSizeLayout,
      showLargeSizeLayout: appAttributes.showLargeSizeLayout,
      children: [
        MarkdownFilePage(
          currentLocale: Localizations.localeOf(context),
          filePathDe: '',
          filePathEn: resolvedConfig.filePath,
          imageDirectory: resolvedConfig.imageDir,
          useLightMode: appAttributes.useLightMode,
        ),
        FileTable(title: appendixTitle, docs: docs),
      ],
    );
  }
}

/// Adapter that lets the deprecated loose-parameter constructor keep working.
class _LegacyMarkdownContentConfig implements MarkdownContentConfig {
  const _LegacyMarkdownContentConfig({
    required this.filePath,
    required this.imageDir,
    required this.docsDesc,
  });

  @override
  final String filePath;

  @override
  final String imageDir;

  @override
  final List<Map<String, String>> docsDesc;
}
