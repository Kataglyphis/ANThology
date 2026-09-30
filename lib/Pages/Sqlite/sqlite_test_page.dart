import 'package:flutter/material.dart';
import 'package:anthology/Layout/ResponsiveDesign/single_page.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Sqlite/sqlite_self_test.dart';
import 'package:anthology/app_attributes.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// Runs [runSqliteSelfTest] on demand and shows its output.
/// Requires [AnthologyLocalizations.delegate] in the host app's `localizationsDelegates`.
class SqliteTestPage extends StatefulWidget {
  const SqliteTestPage({
    super.key,
    required this.appAttributes,
    required this.footer,
    this.errorPrefix,
  });

  final AppAttributes appAttributes;
  final Footer footer;

  /// Prefix for a thrown self-test error; defaults to [AnthologyLocalizations.sqliteSelfTestErrorPrefix].
  final String? errorPrefix;

  @override
  State<StatefulWidget> createState() => SqliteTestPageState();
}

class SqliteTestPageState extends State<SqliteTestPage> {
  bool _isRunning = false;
  String? _result;

  Future<void> _run() async {
    // Resolved before the first await: `context` must not be used across an async gap.
    final String errorPrefix =
        widget.errorPrefix ??
        AnthologyLocalizations.of(context)!.sqliteSelfTestErrorPrefix;

    setState(() {
      _isRunning = true;
      _result = null;
    });

    String result;
    try {
      result = await runSqliteSelfTest();
    } catch (e) {
      result = '$errorPrefix$e';
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _isRunning = false;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AnthologyLocalizations l10n = AnthologyLocalizations.of(context)!;
    return SinglePage(
      footer: widget.footer,
      appAttributes: widget.appAttributes,
      showMediumSizeLayout: widget.appAttributes.showMediumSizeLayout,
      showLargeSizeLayout: widget.appAttributes.showLargeSizeLayout,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.sqliteSelfTestTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.sqliteSelfTestDescription,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _isRunning ? null : _run,
              child: Text(
                _isRunning
                    ? l10n.sqliteSelfTestRunningLabel
                    : l10n.sqliteSelfTestRunLabel,
              ),
            ),
            const SizedBox(height: 16),
            if (_result != null)
              SelectableText(
                _result!,
                style: Theme.of(context).textTheme.titleSmall,
              ),
          ],
        ),
      ],
    );
  }
}
