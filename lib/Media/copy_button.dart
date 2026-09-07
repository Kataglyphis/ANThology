import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:anthology/l10n/anthology_localizations.dart';

class CopyButton extends StatelessWidget {
  final String text;
  const CopyButton({super.key, required this.text});

  void _onPressed() async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      child: Text(
        // Was a hard-coded DE/EN ternary, which served English to every other
        // locale the host app supports.
        AnthologyLocalizations.of(context)!.copyLabel,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
