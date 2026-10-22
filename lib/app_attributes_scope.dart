import 'package:flutter/widgets.dart';

import 'package:anthology/app_attributes.dart';

/// Current shell settings without replacing the router or its page states.
class AppAttributesScope extends InheritedWidget {
  const AppAttributesScope({
    super.key,
    required this.attributes,
    required super.child,
  });

  final AppAttributes attributes;

  static AppAttributes? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<AppAttributesScope>()
      ?.attributes;

  @override
  bool updateShouldNotify(AppAttributesScope oldWidget) =>
      attributes != oldWidget.attributes;
}
