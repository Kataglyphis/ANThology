import 'boot_overlay_native.dart'
    if (dart.library.js_interop) 'boot_overlay_web.dart';

/// Fades out and removes the loading overlay the shared `web/index.html` shell paints before Flutter boots; a no-op off the web.
void dismissBootOverlay() => dismissBootOverlayImpl();
