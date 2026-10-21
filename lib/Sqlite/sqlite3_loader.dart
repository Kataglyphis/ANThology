import 'package:sqlite3/common.dart';

import 'sqlite3_loader_native.dart'
    if (dart.library.js_interop) 'sqlite3_loader_web.dart';

/// SQLite for this platform: the FFI library natively; on the web `sqlite3.wasm`, served beside `index.html`,
/// with IndexedDB [indexedDbName] as its default file system, or an in-memory one when that is null.
///
/// [indexedDbName] names a database in the visitor's browser: a new name opens a new, empty one.
Future<CommonSqlite3> loadSqlite3({String? indexedDbName}) =>
    loadSqlite3Impl(indexedDbName: indexedDbName);
