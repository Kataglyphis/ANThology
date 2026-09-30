import 'sqlite_self_test_impl_stub.dart'
    if (dart.library.js_interop) 'sqlite_self_test_impl_web.dart'
    if (dart.library.io) 'sqlite_self_test_impl_io.dart';

/// Runs a minimal SQLite smoke test on the current platform and returns a readable status.
Future<String> runSqliteSelfTest() => runSqliteSelfTestImpl();
