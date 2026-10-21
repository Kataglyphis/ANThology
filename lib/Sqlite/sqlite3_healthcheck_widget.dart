import 'package:flutter/material.dart';

import 'package:anthology/l10n/anthology_localizations.dart';

/// A SQLite status line, checked on init and re-runnable by its button.
class Sqlite3HealthcheckWidget extends StatefulWidget {
  const Sqlite3HealthcheckWidget({super.key, required this.check});

  /// The check to run, usually `runSqliteHealthcheck` with the app's IndexedDB name.
  final Future<String> Function() check;

  @override
  State<Sqlite3HealthcheckWidget> createState() =>
      _Sqlite3HealthcheckWidgetState();
}

class _Sqlite3HealthcheckWidgetState extends State<Sqlite3HealthcheckWidget> {
  Future<String>? _result;

  @override
  void initState() {
    super.initState();
    _result = widget.check();
  }

  void _rerun() {
    setState(() {
      _result = widget.check();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AnthologyLocalizations l10n = AnthologyLocalizations.of(context)!;

    return Column(
      children: [
        TextButton(onPressed: _rerun, child: Text(l10n.rerunSqliteHealthcheck)),
        FutureBuilder<String>(
          future: _result,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(
                '${l10n.sqliteError}: ${snapshot.error}\n\n${l10n.sqliteWebHint}',
                textAlign: TextAlign.center,
              );
            }
            return Text(
              'SQLite: ${snapshot.data}',
              textAlign: TextAlign.center,
            );
          },
        ),
      ],
    );
  }
}
