import 'package:flutter/material.dart';
import 'package:anthology/Layout/ResponsiveDesign/single_page.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Sqlite/sqlite_self_test.dart';
import 'package:anthology/app_attributes.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// Runs [runSqliteSelfTest] on demand and shows its output.
///
/// All copy on this page comes from [AnthologyLocalizations], so the host app
/// must register [AnthologyLocalizations.delegate] in its
/// `localizationsDelegates`. Title, description and both button labels used to
/// arrive through four `String Function(BuildContext)` closures; the only
/// consumer implemented them as a hand-rolled `localeOf(context) == Locale('de')`
/// ternary, which silently served English to every third locale it shipped.
class SqliteTestPage extends StatefulWidget {
  const SqliteTestPage({
    super.key,
    required this.appAttributes,
    required this.footer,
    this.errorPrefix,
  });

  final AppAttributes appAttributes;
  final Footer footer;

  /// Prefix put in front of a thrown self-test error.
  ///
  /// Defaults to [AnthologyLocalizations.sqliteSelfTestErrorPrefix], which
  /// follows the active locale. Override it only to say something the shared
  /// catalogue cannot.
  final String? errorPrefix;

  @override
  State<StatefulWidget> createState() => SqliteTestPageState();
}

class SqliteTestPageState extends State<SqliteTestPage> {
  bool _isRunning = false;
  String? _result;

  Future<void> _run() async {
    // Resolved before the first await: `context` must not be touched across an
    // async gap, and the prefix is needed only after the self test returns.
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
