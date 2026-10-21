// The native half of the shared SQLite code; the web half needs sqlite3.wasm served, which a test run has not.
@TestOn('vm')
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Sqlite/sqlite3_healthcheck.dart';
import 'package:anthology/Sqlite/sqlite_self_test.dart';

void main() {
  test('the self test runs a query in memory', () async {
    final String result = await runSqliteSelfTest();
    expect(result, startsWith('OK (native): id=1 name=hello sqlite='));
  });

  test(
    'the healthcheck stays in memory natively, whatever the web name',
    () async {
      expect(await runSqliteHealthcheck(), 'OK (Native in-memory, rows=1)');
      expect(
        await runSqliteHealthcheck(indexedDbName: 'some_app'),
        'OK (Native in-memory, rows=1)',
      );
    },
  );
}
