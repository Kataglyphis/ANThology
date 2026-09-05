import 'package:flutter/material.dart';
import 'package:anthology/Pages/Footer/footer_config.dart';
import 'package:anthology/Pages/Home/home_config.dart';
import 'package:anthology/Routing/screen_configurations.dart';
import 'package:anthology/app_settings.dart';
import 'package:anthology/constants.dart';
import 'package:anthology/user_settings.dart';

class AppAttributes {
  UserSettings userSettings;
  AppSettings appSettings;
  FooterConfig footerConfig;
  HomeConfig homeConfig;

  ScreenConfigurations screenConfigurations;

  CurvedAnimation railAnimation;
  bool showMediumSizeLayout;
  bool showLargeSizeLayout;

  int? currentLanguageIndex;
  final void Function(int index)? handleLanguageSelect;

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
    this.currentLanguageIndex,
    required this.colorSelected,
    required this.useLightMode,
    this.handleBrightnessChange,
    this.handleColorSelect,
    this.handleLanguageSelect,
  });
}
