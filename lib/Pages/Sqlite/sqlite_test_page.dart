import 'package:flutter/material.dart';
import 'package:anthology/Layout/ResponsiveDesign/single_page.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Sqlite/sqlite_self_test.dart';
import 'package:anthology/app_attributes.dart';

class SqliteTestPage extends StatefulWidget {
  const SqliteTestPage({
    super.key,
    required this.appAttributes,
    required this.footer,
    required this.titleBuilder,
    required this.descriptionBuilder,
    required this.runLabelBuilder,
    required this.runningLabelBuilder,
    this.errorPrefix = 'ERROR: ',
  });

  final AppAttributes appAttributes;
  final Footer footer;
  final String Function(BuildContext) titleBuilder;
  final String Function(BuildContext) descriptionBuilder;
  final String Function(BuildContext) runLabelBuilder;
  final String Function(BuildContext) runningLabelBuilder;
  final String errorPrefix;

  @override
  State<StatefulWidget> createState() => SqliteTestPageState();
}

class SqliteTestPageState extends State<SqliteTestPage> {
  bool _isRunning = false;
  String? _result;

  Future<void> _run() async {
    setState(() {
      _isRunning = true;
      _result = null;
    });

    String result;
    try {
      result = await runSqliteSelfTest();
    } catch (e) {
      result = '${widget.errorPrefix}$e';
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
              widget.titleBuilder(context),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              widget.descriptionBuilder(context),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: _isRunning ? null : _run,
              child: Text(
                _isRunning
                    ? widget.runningLabelBuilder(context)
                    : widget.runLabelBuilder(context),
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
