import 'package:sqlite3/sqlite3.dart';

/// The FFI library; [indexedDbName] is a web-only setting.
Future<CommonSqlite3> loadSqlite3Impl({String? indexedDbName}) async {
  return sqlite3;
}
