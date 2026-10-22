import 'package:flutter/material.dart';

import 'package:anthology/Media/Files/file_actions.dart';

class DownloadButton extends StatelessWidget {
  final String assetFullPath;
  final FileActions? fileActions;
  const DownloadButton({
    super.key,
    required this.assetFullPath,
    this.fileActions,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.file_download, size: 44),
      onPressed: () => performFileAction(
        context,
        () => (fileActions ?? defaultFileActions).save(assetFullPath),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
