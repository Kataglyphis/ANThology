import 'package:web/web.dart' as web;

import 'package:flutter/foundation.dart';

void myPluginOpen(String url) {
  if (kReleaseMode) {
    url = "assets/$url";
  }
  web.window.open(url, "_blank");
}
