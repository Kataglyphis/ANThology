import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:anthology/Pages/Home/button_names.dart';
import 'package:anthology/Pages/Home/home_config.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// The [HomeConfig] both apps were carrying a private, byte-identical copy of.
///
/// Labels come from [AnthologyLocalizations], so its delegate must be
/// registered on the enclosing [MaterialApp].
class DefaultHomeConfig extends HomeConfig {
  @override
  ButtonNames getButtonNames(BuildContext context) {
    final localizations = AnthologyLocalizations.of(context)!;
    return ButtonNames(
      brightness: localizations.toogleBrightness,
      // for now i want my app color NOT selectable in production
      color: (kDebugMode) ? localizations.selectSeedColor : null,
      language: localizations.switchLang,
    );
  }
}
