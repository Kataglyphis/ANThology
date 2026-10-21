import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqlite3/common.dart';

import 'package:anthology/Sqlite/sqlite3_loader.dart';

/// Adds a row and counts them: kept across visits on the web when [indexedDbName] names an IndexedDB database,
/// in memory otherwise, so no writable directory must be picked natively.
///
/// [webDatabasePath] is the file inside that database; changing either value starts the count afresh.
Future<String> runSqliteHealthcheck({
  String? indexedDbName,
  String webDatabasePath = '/healthcheck.db',
}) async {
  final CommonSqlite3 sqlite = await loadSqlite3(indexedDbName: indexedDbName);
  final bool persistent = kIsWeb && indexedDbName != null;

  final CommonDatabase db = kIsWeb
      ? sqlite.open(webDatabasePath)
      : sqlite.openInMemory();

  try {
    db.execute(
      'CREATE TABLE IF NOT EXISTS healthcheck (id INTEGER PRIMARY KEY AUTOINCREMENT, created_at TEXT NOT NULL);',
    );

    db.execute(
      "INSERT INTO healthcheck (created_at) VALUES (datetime('now'));",
    );

    final ResultSet rows = db.select('SELECT COUNT(*) AS c FROM healthcheck;');
    final Object? count = rows.first['c'];

    if (!kIsWeb) return 'OK (Native in-memory, rows=$count)';
    return persistent
        ? 'OK (Web persistent, rows=$count)'
        : 'OK (Web in-memory, rows=$count)';
  } finally {
    db.close();
  }
}
