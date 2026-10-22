import 'package:flutter/material.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

import 'package:anthology/Media/Files/file_actions.dart';
import 'package:mime/mime.dart';

class OpenButton extends StatelessWidget {
  final String assetFullPath;
  final FileActions? fileActions;
  const OpenButton({super.key, required this.assetFullPath, this.fileActions});

  // https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
  bool isDisabled() {
    String? mimType = lookupMimeType(assetFullPath);
    if (mimType != null) {
      if (mimType.startsWith('image') || mimType == 'application/pdf') {
        return false;
      }
      return true;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled()
          ? null
          : () => performFileAction(
              context,
              () => (fileActions ?? defaultFileActions).open(assetFullPath),
            ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      child: Text(
        AnthologyLocalizations.of(context)!.openLabel,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
