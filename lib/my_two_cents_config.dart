import 'package:anthology/Pages/markdown_content_page.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';
import 'package:anthology/json_helpers.dart';

/// Configuration for a "My Two Cents" / media critics page loaded from JSON.
///
/// This class holds metadata and content paths for opinion/review pages.
/// Implements [MarkdownContentConfig] to enable use with [MarkdownContentPage].
class MyTwoCentsConfig extends StatefulBranchInfoProvider
    implements MarkdownContentConfig {
  /// Creates a [MyTwoCentsConfig] from a JSON map.
  ///
  /// Throws [FormatException] if a required field is missing or has the wrong
  /// type, rather than rendering a blank page from a malformed settings file.
  MyTwoCentsConfig.fromJsonFile(Map<String, dynamic> jsonFile)
    : routingName = requireStringField(jsonFile, 'routingName'),
      filePath = requireStringField(jsonFile, 'filePath'),
      imageDir = requireStringField(jsonFile, 'imageDir'),
      mediaTitle = requireStringField(jsonFile, 'mediaTitle'),
      fileBaseDir = requireStringField(jsonFile, 'fileBaseDir'),
      docsDesc = parseDocsDesc(jsonFile['docsDesc']);

  /// The URL-friendly name used for routing.
  final String routingName;

  /// Path to the markdown content file.
  @override
  final String filePath;

  /// Directory containing images referenced in the markdown.
  @override
  final String imageDir;

  /// Title of the media being reviewed/discussed.
  final String mediaTitle;

  /// Base directory for file downloads.
  final String fileBaseDir;

  /// List of appendix document configurations.
  @override
  final List<Map<String, String>> docsDesc;

  @override
  String getRoutingName() => routingName;
}
