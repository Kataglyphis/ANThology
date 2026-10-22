# ANThology test support

Shared widget contracts for ANThology consumers. Add this package as a dev dependency with
`path: third_party/ANThology/packages/anthology_test_support`; the production UI package does
not depend on `flutter_test`.

```dart
@TestOn('vm')
library;

import 'package:anthology_test_support/app_contracts.dart';
import 'package:flutter_test/flutter_test.dart' show TestOn;
import 'package:my_app/main.dart';

void main() {
  registerAppLayoutTests(app: () => const App(), routes: ['/home', '/settings']);
  registerAppNavigationContract(
    app: () => const App(),
    navigationIndex: 1,
    route: '/settings',
  );
}
```

Layout checks cover the supplied routes at phone, tablet and desktop sizes, including enlarged
text. Navigation checks tap the bottom bar and appearance controls and verify that the router
and selected route survive language, theme and breakpoint changes. Run these contracts on the
VM: they load the consumer's real bundled assets and ANThology's fonts.
