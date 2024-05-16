import 'package:flutter/material.dart';
import 'package:jotrockenmitlockenrepo/Decoration/centered_box_decoration.dart';
import 'package:jotrockenmitlockenrepo/Media/Download/download_button.dart';
import 'package:jotrockenmitlockenrepo/Media/Files/file.dart';

class FileDownloadIcon extends StatelessWidget {
  final File document;
  const FileDownloadIcon({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).colorScheme.primary;
    return AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: SizedBox(
          width: 70,
          height: 70,
          child: CenteredBoxDecoration(
              child: Center(
                  child: DownloadButton(
                      assetFullPath: document.baseDir + document.title)),
              color: selectedColor),
        ),
      ),
    );
  }
}
