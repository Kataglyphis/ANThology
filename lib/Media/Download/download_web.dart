import 'package:anthology/Media/Files/file_actions.dart';

String trimAfterLastSlash(String input) {
  int lastSlashIndex = input.lastIndexOf('/');
  if (lastSlashIndex == -1) {
    // If no slash is found, return the original string
    return input;
  }
  // Return the substring after the last slash
  return input.substring(lastSlashIndex + 1);
}

Future<void> myPluginDownload(String url) => defaultFileActions.save(url);
