import 'package:flutter/material.dart';
import 'package:anthology/Decoration/centered_box_decoration.dart';
import 'package:anthology/Media/Download/download_button.dart';
import 'package:anthology/Media/Files/file.dart';

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
            color: selectedColor,
            child: Center(
              child: DownloadButton(
                assetFullPath: document.baseDir + document.title,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
