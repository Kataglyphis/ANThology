import 'package:flutter/material.dart';
import 'package:anthology/Pages/navbar_page_config.dart';

class GenericNavBarPageConfig extends NavBarPageConfig {
  final IconData icon;
  final IconData selectedIcon;
  final String Function(BuildContext) labelBuilder;
  final String routingName;

  GenericNavBarPageConfig({
    required this.icon,
    required this.selectedIcon,
    required this.labelBuilder,
    required this.routingName,
  });

  @override
  NavigationDestination getNavigationDestination(BuildContext context) {
    return NavigationDestination(
      tooltip: '',
      icon: Icon(icon),
      label: labelBuilder(context),
      selectedIcon: Icon(selectedIcon),
    );
  }

  @override
  String getRoutingName() {
    return routingName;
  }
}
