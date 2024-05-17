import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart';

void myPluginDownload(String url) {
  if (kReleaseMode) {
    url = "assets/$url";
  }
  web.HTMLAnchorElement anchorElement = web.HTMLAnchorElement();
  anchorElement.href = url;
  anchorElement.download = url;
  anchorElement.click();
}
