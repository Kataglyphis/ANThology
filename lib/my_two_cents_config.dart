import 'package:anthology/Pages/markdown_content_page.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';
import 'package:anthology/json_helpers.dart';

/// A "My Two Cents" review page's metadata and content paths from JSON, usable with [MarkdownContentPage].
class MyTwoCentsConfig extends StatefulBranchInfoProvider
    implements MarkdownContentConfig {
  /// Throws [FormatException] on a missing or mistyped field rather than rendering a blank page.
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
