import 'package:sqlite3/wasm.dart';

Future<String> runSqliteSelfTestImpl() async {
  try {
    final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
    sqlite.registerVirtualFileSystem(InMemoryFileSystem(), makeDefault: true);

    final db = sqlite.open('/selftest.db');
    try {
      db.execute(
        'CREATE TABLE IF NOT EXISTS t (id INTEGER PRIMARY KEY, name TEXT NOT NULL);',
      );
      db.execute('DELETE FROM t;');
      db.execute('INSERT INTO t (name) VALUES (?)', ['hello-web']);

      final row = db.select(
        'SELECT id, name, sqlite_version() AS v FROM t LIMIT 1;',
      );

      final id = row.first['id'];
      final name = row.first['name'];
      final version = row.first['v'];

      return 'OK (web/wasm): id=$id name=$name sqlite=$version';
    } finally {
      db.close();
    }
  } catch (e) {
    return 'ERROR: Could not load sqlite3.wasm. Place the file at web/sqlite3.wasm (see pub.dev/package/sqlite3 → WASM setup). Details: $e';
  }
}
