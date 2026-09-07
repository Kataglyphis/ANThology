import 'package:flutter/material.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Layout/ResponsiveDesign/single_page.dart';
import 'package:anthology/Media/Files/file.dart';
import 'package:anthology/Media/Files/file_table.dart';
import 'package:anthology/Media/Markdown/markdown_page.dart';
import 'package:anthology/app_attributes.dart';

/// Configuration interface for pages that display markdown content with an
/// appendix file table.
///
/// Implement this on a page config (a blog entry, a media review, ...) and pass
/// the config straight to [MarkdownContentPage]; the page needs nothing else.
abstract class MarkdownContentConfig {
  /// The path to the markdown file to display.
  String get filePath;

  /// The directory containing images referenced in the markdown.
  String get imageDir;

  /// List of appendix documents with their metadata.
  ///
  /// Each map should contain:
  /// - 'baseDir': The base directory for the file
  /// - 'title': The display title
  /// - 'additionalInfo': Additional information about the file
  List<Map<String, String>> get docsDesc;
}

/// A reusable widget for displaying markdown content with an appendix file
/// table.
///
/// Example usage:
/// ```dart
/// MarkdownContentPage(
///   appAttributes: appAttributes,
///   footer: footer,
///   config: blogPageConfig,
///   appendixTitle: 'References',
/// )
/// ```
class MarkdownContentPage extends StatelessWidget {
  /// The application-wide attributes for theming and layout.
  final AppAttributes appAttributes;

  /// The footer widget to display at the bottom of the page.
  final Footer footer;

  /// The title displayed above the appendix file table.
  ///
  /// Defaults to 'Appendix' if not specified.
  final String appendixTitle;

  final MarkdownContentConfig? _config;
  final String? _legacyFilePath;
  final String? _legacyImageDir;
  final List<Map<String, String>>? _legacyDocsDesc;

  /// Creates a markdown content page.
  ///
  /// Pass [config]. The [filePath], [imageDir] and [docsDesc] parameters are
  /// the pre-1.2 signature, kept so that existing consumers of this public
  /// package keep compiling; they will be removed in a future major release.
  /// Supply exactly one of the two forms.
  ///
  /// The `@Deprecated` annotations below are documentation only: this SDK's
  /// analyzer does not raise `deprecated_member_use` for a formal parameter
  /// (verified - a test calling the old form analyses clean), so a consumer
  /// learns about the migration from the docs, not from a warning.
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

  /// The resolved configuration backing this page.
  ///
  /// Throws a [StateError] - in release builds too, where the constructor
  /// assert does not run - when neither form was supplied, rather than
  /// rendering a silently empty page.
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
