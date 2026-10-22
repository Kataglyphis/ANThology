import 'package:flutter/material.dart';

import 'package:anthology/Media/Files/file_actions_contract.dart';
import 'package:anthology/Media/Files/file_actions_native.dart'
    if (dart.library.js_interop) 'package:anthology/Media/Files/file_actions_web.dart'
    as platform;
import 'package:anthology/l10n/anthology_localizations.dart';

export 'package:anthology/Media/Files/file_actions_contract.dart';

final FileActions defaultFileActions = platform.createFileActions();

/// Reports action failures in the page instead of letting a button callback throw.
Future<void> performFileAction(
  BuildContext context,
  Future<void> Function() action,
) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final message = AnthologyLocalizations.of(context)!.fileActionFailed;
  try {
    await action();
  } catch (error, stack) {
    debugPrint('File action failed: $error\n$stack');
    if (context.mounted) {
      messenger?.showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
