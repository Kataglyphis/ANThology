import 'package:web/web.dart' as web;

import 'package:anthology/Media/Files/file_actions_contract.dart';

FileActions createFileActions() => const WebFileActions();

/// Browser actions use Flutter's asset URL prefix in every build mode.
class WebFileActions implements FileActions {
  const WebFileActions();

  @override
  Future<void> open(String asset) async {
    web.window.open('assets/$asset', '_blank', 'noopener');
  }

  @override
  Future<void> save(String asset) async {
    web.HTMLAnchorElement()
      ..href = 'assets/$asset'
      ..download = asset.split('/').last
      ..click();
  }
}
