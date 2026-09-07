import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:anthology/Decoration/col_divider.dart';
import 'package:anthology/Decoration/row_divider.dart';
import 'package:anthology/Decoration/component_group_decoration.dart';
import 'package:anthology/Media/Files/file.dart';
import 'package:anthology/Media/Files/file_tile.dart';
import 'package:anthology/Media/Image/openable_image.dart';
import 'package:anthology/Url/browser_helper.dart';
import 'package:flutter/material.dart';
import 'package:anthology/Url/external_link_config.dart';

class LandingPageEntry extends StatefulWidget {
  const LandingPageEntry({
    super.key,
    required this.label,
    required this.routerPath,
    required this.headline,
    required this.imagePath,
    this.githubRepo,
    required this.description,
    required this.lastModified,
    required this.fileTitle,
    required this.fileAdditionalInfo,
    required this.fileBaseDir,
    this.imageCaptioning,
  });
  final String label;
  final String routerPath;
  final String headline;
  final String imagePath;
  final String description;

  /// Source repository for this entry, or null when the app has no GitHub
  /// link configured. Null hides the icon rather than guessing a URL.
  final ExternalLinkConfig? githubRepo;
  final String? imageCaptioning;
  final String lastModified;
  final String fileTitle;
  final String fileAdditionalInfo;
  final String fileBaseDir;

  @override
  State<LandingPageEntry> createState() => LandingPageEntryState();
}

class LandingPageEntryState extends State<LandingPageEntry> {
  bool isDisabled = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> undecoratedChilds = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.githubRepo != null)
            IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              onPressed: () {
                BrowserHelper.launchInBrowser(widget.githubRepo!);
              },
            ),
          colDivider,
          Text(
            widget.description,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
      // //rowDivider,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.tonal(
            onPressed: isDisabled
                ? null
                : () {
                    context.go(widget.routerPath);
                  },
            child: Text(
              widget.headline,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
      rowDivider,
      OpenableImage(
        displayedImage: widget.imagePath,
        disableOpen: true,
        imageCaptioning: widget.imageCaptioning,
      ),
      rowDivider,
      IntrinsicWidth(
        child: FileTile(
          currentDocument: File(
            title: widget.fileTitle,
            additionalInfo: widget.fileAdditionalInfo,
            baseDir: widget.fileBaseDir,
          ),
        ),
      ),
      rowDivider,
      Padding(
        padding: const EdgeInsets.only(right: 34.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              widget.lastModified,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComponentGroupDecoration(
            label: widget.label,
            children: <Widget>[...undecoratedChilds],
          ),
        ],
      ),
    );
  }
}
