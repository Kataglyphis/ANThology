import 'package:sqlite3/wasm.dart';

WasmSqlite3? _sqlite;
final Map<String, IndexedDbFileSystem> _indexedDbs =
    <String, IndexedDbFileSystem>{};
InMemoryFileSystem? _inMemory;

/// Loads sqlite3.wasm once; throws [StateError] if it or IndexedDB is unavailable.
Future<CommonSqlite3> loadSqlite3Impl({String? indexedDbName}) async {
  try {
    _sqlite ??= await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
  } catch (e) {
    throw StateError(
      'Failed to load SQLite3 WASM. Ensure sqlite3.wasm is served beside index.html '
      '(the build copies web/sqlite3.wasm there). '
      'Error: $e',
    );
  }
  final WasmSqlite3 sqlite = _sqlite!;

  if (indexedDbName == null) {
    // Registered once: a second registration under the same name throws.
    if (_inMemory == null) {
      _inMemory = InMemoryFileSystem();
      sqlite.registerVirtualFileSystem(_inMemory!, makeDefault: true);
    }
    return sqlite;
  }

  try {
    if (!_indexedDbs.containsKey(indexedDbName)) {
      final IndexedDbFileSystem fileSystem = await IndexedDbFileSystem.open(
        dbName: indexedDbName,
      );
      sqlite.registerVirtualFileSystem(fileSystem, makeDefault: true);
      _indexedDbs[indexedDbName] = fileSystem;
    }
  } catch (e) {
    throw StateError(
      'Failed to initialize IndexedDB file system for SQLite. '
      'Ensure IndexedDB is available in your browser. Error: $e',
    );
  }
  return sqlite;
}
