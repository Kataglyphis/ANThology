import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:markdown_widget/markdown_widget.dart';
import 'package:anthology/Decoration/row_divider.dart';
import 'package:anthology/constants.dart';

// A fenced code block, kept whole, or an HTML comment, which markdown_widget would print as text.
final RegExp _fenceOrComment = RegExp(
  r'(^[ \t]*(```|~~~)[\s\S]*?^[ \t]*\2)|<!--[\s\S]*?-->',
  multiLine: true,
);

final RegExp _fence = RegExp(
  r'^[ \t]*(```|~~~)[\s\S]*?^[ \t]*\1',
  multiLine: true,
);

final RegExp _imageDestination = RegExp(r'(!\[[^\]]*\]\()([^)\s]+)');

/// [markdown] without its HTML comments; fenced code keeps them.
String withoutHtmlComments(String markdown) =>
    markdown.replaceAllMapped(_fenceOrComment, (Match m) => m[1] ?? '');

/// The asset an image [src] of the Markdown file [markdownPath] shows: [src], relative to the file, or under [imageDirectory] by path or name; null when none is bundled.
String? resolveMarkdownImage(
  String src, {
  required String markdownPath,
  required String imageDirectory,
  required Set<String> assets,
}) {
  if (src.contains('://') || src.startsWith('data:')) return null;
  final String directory = markdownPath.substring(
    0,
    markdownPath.lastIndexOf('/') + 1,
  );
  final String images = imageDirectory.isEmpty || imageDirectory.endsWith('/')
      ? imageDirectory
      : '$imageDirectory/';
  String relativeTo(String dir) =>
      Uri.decodeFull(Uri(path: dir).resolve(src).path);
  for (final String candidate in <String>[
    src,
    relativeTo(directory),
    relativeTo(images),
    '$images${src.split('/').last}',
  ]) {
    if (assets.contains(candidate)) return candidate;
  }
  return null;
}

/// [markdown] with each image destination [resolve] maps replaced by its result; fenced code is kept as written.
String withResolvedImages(
  String markdown,
  String? Function(String src) resolve,
) {
  String rewrite(String text) => text.replaceAllMapped(
    _imageDestination,
    (Match m) => '${m[1]}${resolve(m[2]!) ?? m[2]}',
  );
  final StringBuffer out = StringBuffer();
  int last = 0;
  for (final Match fence in _fence.allMatches(markdown)) {
    out
      ..write(rewrite(markdown.substring(last, fence.start)))
      ..write(fence[0]);
    last = fence.end;
  }
  return (out..write(rewrite(markdown.substring(last)))).toString();
}

Future<Set<String>>? _bundledAssets;

/// Every asset key of the app's bundle, read once; empty when the manifest cannot be read.
Future<Set<String>> bundledAssets() =>
    _bundledAssets ??= AssetManifest.loadFromAssetBundle(rootBundle).then(
      (AssetManifest manifest) => manifest.listAssets().toSet(),
      onError: (Object e) {
        developer.log('Error reading the asset manifest: $e');
        return <String>{};
      },
    );

class MarkdownFilePage extends StatefulWidget {
  const MarkdownFilePage({
    super.key,
    required this.currentLocale,
    required this.filePathDe,
    required this.filePathEn,
    this.imageDirectory = 'packages/anthology/assets/images/',
    required this.useLightMode,
  });

  final Locale currentLocale;
  final String filePathDe;
  final String filePathEn;
  final String imageDirectory;
  final bool useLightMode;

  @override
  MarkdownFilePageState createState() => MarkdownFilePageState();
}

class MarkdownFilePageState extends State<MarkdownFilePage> {
  late Future<String> _markupFileContent;

  @override
  void initState() {
    super.initState();
    final String path = _markupPath();
    // An image path the bundle lacks would be fetched anyway and 404: blog posts name theirs relative to the file.
    _markupFileContent =
        Future.wait<Object>(<Future<Object>>[
          _readMarkupFile(path),
          bundledAssets(),
        ]).then(
          (List<Object> read) => withResolvedImages(
            withoutHtmlComments(read[0] as String),
            (String src) => resolveMarkdownImage(
              src,
              markdownPath: path,
              imageDirectory: widget.imageDirectory,
              assets: read[1] as Set<String>,
            ),
          ),
        );
  }

  /// German when the locale asks for it and the page has it, else English, else German.
  String _markupPath() {
    if (widget.currentLocale == const Locale('de') &&
        widget.filePathDe.isNotEmpty) {
      return widget.filePathDe;
    }
    return widget.filePathEn.isNotEmpty ? widget.filePathEn : widget.filePathDe;
  }

  Future<String> _readMarkupFile(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      developer.log("Error reading file: $e");
      return '';
    }
  }

  double getMarkdownPageWidth() {
    return responsiveWidth(MediaQuery.of(context).size.width, large: 0.7);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        rowDivider,
        FutureBuilder<String>(
          future: _markupFileContent,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                width: getMarkdownPageWidth(),
                child: Center(
                  child: MarkdownWidget(
                    shrinkWrap: true,
                    data: snapshot.data!,

                    config: config.copy(
                      configs: [
                        isDark
                            ? PreConfig.darkConfig.copy()
                            : PreConfig().copy(),
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
