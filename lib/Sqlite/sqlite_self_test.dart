import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqlite3/common.dart';

import 'package:anthology/Sqlite/sqlite3_loader.dart';

/// Runs a minimal SQLite query in memory and returns a readable status; throws when SQLite cannot load.
Future<String> runSqliteSelfTest() async {
  final CommonSqlite3 sqlite = await loadSqlite3();
  final CommonDatabase db = sqlite.openInMemory();
  try {
    db.execute('CREATE TABLE t (id INTEGER PRIMARY KEY, name TEXT NOT NULL);');
    db.execute('INSERT INTO t (name) VALUES (?)', ['hello']);

    final ResultSet row = db.select(
      'SELECT id, name, sqlite_version() AS v FROM t LIMIT 1;',
    );

    final Object? id = row.first['id'];
    final Object? name = row.first['name'];
    final Object? version = row.first['v'];

    return 'OK (${kIsWeb ? 'web/wasm' : 'native'}): id=$id name=$name sqlite=$version';
  } finally {
    db.close();
  }
}
