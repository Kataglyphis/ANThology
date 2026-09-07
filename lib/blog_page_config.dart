import 'package:anthology/Pages/markdown_content_page.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';
import 'package:anthology/json_helpers.dart';

/// Alignment options for landing page entries.
enum LandingPageAlignment { left, right }

/// Configuration for a blog page loaded from JSON settings.
///
/// This class holds all metadata and content paths needed to render a blog post,
/// including the markdown file path, image directory, and appendix documents.
///
/// Implements [MarkdownContentConfig] to enable use with [MarkdownContentPage].
class BlogPageConfig extends StatefulBranchInfoProvider
    implements MarkdownContentConfig {
  /// Creates a [BlogPageConfig] from a JSON map.
  ///
  /// Throws [FormatException] if a required field is missing or has the wrong
  /// type, rather than rendering a blank page from a malformed settings file.
  BlogPageConfig.fromJsonFile(Map<String, dynamic> jsonFile)
    : routingName = requireStringField(jsonFile, 'routingName'),
      shortDescriptionEN = requireStringField(jsonFile, 'shortDescriptionEN'),
      shortDescriptionDE = requireStringField(jsonFile, 'shortDescriptionDE'),
      filePath = requireStringField(jsonFile, 'filePath'),
      imageDir = requireStringField(jsonFile, 'imageDir'),
      githubRepo = requireStringField(jsonFile, 'githubRepo'),
      landingPageAlignment = requireStringField(
        jsonFile,
        'landingPageAlignment',
      ),
      landingPageEntryImagePath = requireStringField(
        jsonFile,
        'landingPageEntryImagePath',
      ),
      landingPageEntryImageCaptioning =
          jsonFile['landingPageEntryImageCaptioning'] as String?,
      lastModified = requireStringField(jsonFile, 'lastModified'),
      fileTitle = requireStringField(jsonFile, 'fileTitle'),
      fileAdditionalInfo = requireStringField(jsonFile, 'fileAdditionalInfo'),
      fileBaseDir = requireStringField(jsonFile, 'fileBaseDir'),
      docsDesc = parseDocsDesc(jsonFile['docsDesc']);

  /// The URL-friendly name used for routing.
  final String routingName;

  /// Short description in English for previews and SEO.
  final String shortDescriptionEN;

  /// Short description in German for previews and SEO.
  final String shortDescriptionDE;

  /// Path to the markdown content file.
  @override
  final String filePath;

  /// Directory containing images referenced in the markdown.
  @override
  final String imageDir;

  /// GitHub repository URL for the project.
  final String githubRepo;

  /// Alignment of the entry on the landing page ('left' or 'right').
  final String landingPageAlignment;

  /// Path to the image displayed on the landing page.
  final String landingPageEntryImagePath;

  /// Optional caption for the landing page image.
  final String? landingPageEntryImageCaptioning;

  /// Last modification date string.
  final String lastModified;

  /// Title of the associated file.
  final String fileTitle;

  /// Additional information about the file.
  final String fileAdditionalInfo;

  /// Base directory for file downloads.
  final String fileBaseDir;

  /// List of appendix document configurations.
  @override
  final List<Map<String, String>> docsDesc;

  @override
  String getRoutingName() => routingName;
}
