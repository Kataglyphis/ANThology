import 'package:flutter/material.dart';
import 'package:jotrockenmitlockenrepo/Pages/Footer/footer.dart';
import 'package:jotrockenmitlockenrepo/Layout/ResponsiveDesign/single_page.dart';
import 'package:jotrockenmitlockenrepo/Media/Files/file.dart';
import 'package:jotrockenmitlockenrepo/Media/Files/file_table.dart';
import 'package:jotrockenmitlockenrepo/Media/Markdown/markdown_page.dart';
import 'package:jotrockenmitlockenrepo/app_attributes.dart';

class MarkdownContentPage extends StatefulWidget {
  final AppAttributes appAttributes;
  final Footer footer;
  final String filePath;
  final String imageDir;
  final List<Map<String, String>> docsDesc;
  const MarkdownContentPage({
    super.key,
    required this.appAttributes,
    required this.footer,
    required this.filePath,
    required this.imageDir,
    required this.docsDesc,
  });

  @override
  State<StatefulWidget> createState() => MarkdownContentPageState();
}

class MarkdownContentPageState extends State<MarkdownContentPage> {
  @override
  Widget build(BuildContext context) {
    List<File> docs = widget.docsDesc
        .map(
          (fileConfig) => File(
            baseDir: fileConfig['baseDir']!,
            title: fileConfig['title']!,
            additionalInfo: fileConfig['additionalInfo']!,
          ),
        )
        .toList();
    return SinglePage(
      footer: widget.footer,
      appAttributes: widget.appAttributes,
      showMediumSizeLayout: widget.appAttributes.showMediumSizeLayout,
      showLargeSizeLayout: widget.appAttributes.showLargeSizeLayout,
      children: [
        MarkdownFilePage(
          currentLocale: Localizations.localeOf(context),
          filePathDe: '',
          filePathEn: widget.filePath,
          imageDirectory: widget.imageDir,
          useLightMode: widget.appAttributes.useLightMode,
        ),
        FileTable(title: 'Appendix', docs: docs),
      ],
    );
  }
}
