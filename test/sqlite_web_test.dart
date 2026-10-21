// The web half of the shared SQLite code; a test page serves no sqlite3.wasm, so this is the error a site without it shows.
@TestOn('browser')
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Sqlite/sqlite3_healthcheck.dart';
import 'package:anthology/Sqlite/sqlite3_loader.dart';
import 'package:anthology/Sqlite/sqlite_self_test.dart';

final Matcher _namesTheWasm = throwsA(
  isA<StateError>().having(
    (StateError e) => e.message,
    'message',
    contains('Ensure sqlite3.wasm is served beside index.html'),
  ),
);

void main() {
  test('without sqlite3.wasm the loader says where it belongs', () async {
    await expectLater(loadSqlite3(), _namesTheWasm);
    await expectLater(
      loadSqlite3(indexedDbName: 'anthology_test'),
      _namesTheWasm,
    );
  });

  test('the self test and the healthcheck pass that error on', () async {
    await expectLater(runSqliteSelfTest(), _namesTheWasm);
    await expectLater(
      runSqliteHealthcheck(indexedDbName: 'anthology_test'),
      _namesTheWasm,
    );
  });
}
