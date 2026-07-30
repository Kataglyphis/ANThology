import 'package:flutter/material.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.supportedLocales,
    required this.currentLanguageIndex,
    required this.handleLanguageSelect,
    this.showTooltipBelow = true,
    required this.title,
    this.compact = true,
  });

  final List<String> supportedLocales;
  final int currentLanguageIndex;
  final void Function(int index) handleLanguageSelect;
  final bool showTooltipBelow;
  final String title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final menu = PopupMenuButton<int>(
      tooltip: '',
      onSelected: handleLanguageSelect,
      itemBuilder: (context) => [
        for (int i = 0; i < supportedLocales.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  child: i == currentLanguageIndex
                      ? const Icon(Icons.check, size: 18)
                      : null,
                ),
                const SizedBox(width: 8),
                Text(supportedLocales[i].toUpperCase()),
              ],
            ),
          ),
      ],
      icon: compact ? const Icon(Icons.translate) : null,
      child: compact
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(supportedLocales[currentLanguageIndex].toUpperCase()),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
    );
    return Tooltip(preferBelow: showTooltipBelow, message: title, child: menu);
  }
}
