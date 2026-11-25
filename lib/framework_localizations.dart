import 'package:cupertino_ui/cupertino_ui.dart'
    show GlobalCupertinoLocalizations;
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show GlobalMaterialLocalizations;

import 'l10n/anthology_localizations.dart';

/// The framework delegates for both Material copies: material_ui's, and via gen-l10n's list flutter/material's, which packages such as markdown_widget still read.
const List<LocalizationsDelegate<dynamic>> frameworkLocalizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  ...AnthologyLocalizations.localizationsDelegates,
];

/// ANThology's own delegate plus the framework's, for a host or test that does not go through the app shell.
const List<LocalizationsDelegate<dynamic>> anthologyLocalizationsDelegates =
    frameworkLocalizationsDelegates;
