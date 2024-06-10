import 'package:web/web.dart';
import 'package:flutter/foundation.dart';

String trimAfterLastSlash(String input) {
  int lastSlashIndex = input.lastIndexOf('/');
  if (lastSlashIndex == -1) {
    // If no slash is found, return the original string
    return input;
  }
  // Return the substring after the last slash
  return input.substring(lastSlashIndex + 1);
}

void myPluginDownload(String url) {
  if (kReleaseMode) {
    url = "assets/$url";
  }
  HTMLAnchorElement()
    ..href = url
    ..download = trimAfterLastSlash(url)
    ..click();
  // HTMLAnchorElement anchorElement = web.HTMLAnchorElement();
  // anchorElement.download = trimAfterLastSlash(url);
  // anchorElement.href = url;
  // anchorElement.click();
}
