import 'package:web/web.dart';

// import 'package:flutter/foundation.dart';

void myPluginOpen(String url) {
  // if (kReleaseMode) {
  //   url = "assets/$url";
  // }
  window.open(url, "_blank");
}
