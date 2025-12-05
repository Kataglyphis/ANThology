import 'package:flutter/material.dart';
import 'package:jotrockenmitlockenrepo/Pages/Footer/footer_config.dart';
import 'package:jotrockenmitlockenrepo/Pages/Home/home_config.dart';
import 'package:jotrockenmitlockenrepo/Routing/screen_configurations.dart';
import 'package:jotrockenmitlockenrepo/app_settings.dart';
import 'package:jotrockenmitlockenrepo/constants.dart';
import 'package:jotrockenmitlockenrepo/user_settings.dart';

class AppAttributes {
  UserSettings userSettings;
  AppSettings appSettings;
  FooterConfig footerConfig;
  HomeConfig homeConfig;

  ScreenConfigurations screenConfigurations;

  CurvedAnimation railAnimation;
  bool showMediumSizeLayout;
  bool showLargeSizeLayout;

  bool? useOtherLanguageMode;
  final void Function()? handleLanguageChange;

  bool useLightMode;
  final void Function(bool useLightMode)? handleBrightnessChange;

  ColorSeed colorSelected;
  final void Function(int value)? handleColorSelect;

  AppAttributes({
    required this.footerConfig,
    required this.homeConfig,
    required this.appSettings,
    required this.userSettings,
    required this.screenConfigurations,
    required this.railAnimation,
    required this.showMediumSizeLayout,
    required this.showLargeSizeLayout,
    this.useOtherLanguageMode,
    required this.colorSelected,
    required this.useLightMode,
    this.handleBrightnessChange,
    this.handleColorSelect,
    this.handleLanguageChange,
  });
}
