import 'dart:convert' show json;
import 'dart:developer' as developer;

import 'package:flutter/services.dart' show rootBundle;

import 'package:anthology/app_settings.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/my_two_cents_config.dart';
import 'package:anthology/user_settings.dart';

/// The three settings files both apps boot from.
typedef SharedSettings = (AppSettings, UserSettings, List<BlogPageConfig>);

/// Reads settings JSON off the asset bundle; a missing or malformed file is logged and rethrown, never swallowed.
class SettingsLoader {
  SettingsLoader({Future<String> Function(String path)? loadString})
    : _loadString = loadString ?? rootBundle.loadString;

  final Future<String> Function(String path) _loadString;

  /// The app, user and blog settings, read in parallel; the first failure is rethrown as it was thrown.
  Future<SharedSettings> loadShared({
    required String userSettingsPath,
    required String appSettingsPath,
    required String blogSettingsPath,
  }) async {
    final List<Object> results = await Future.wait<Object>([
      load(userSettingsPath, parseUserSettings),
      load(appSettingsPath, parseAppSettings),
      load(blogSettingsPath, parseBlogPageConfigs),
    ]);
    return (
      results[1] as AppSettings,
      results[0] as UserSettings,
      results[2] as List<BlogPageConfig>,
    );
  }

  /// [path]'s JSON, decoded and handed to [parse].
  Future<T> load<T>(String path, T Function(Object? json) parse) async {
    final String text;
    try {
      text = await _loadString(path);
    } catch (e) {
      developer.log(
        'Failed to load $path: $e',
        name: 'SettingsLoader',
        error: e,
      );
      rethrow;
    }
    try {
      return parse(json.decode(text));
    } catch (e) {
      developer.log(
        'Failed to parse $path: $e',
        name: 'SettingsLoader',
        error: e,
      );
      rethrow;
    }
  }
}

/// A user settings object, as `global_user_settings.json` holds it.
UserSettings parseUserSettings(Object? json) =>
    UserSettings.fromJsonFile(json as Map<String, dynamic>);

/// An app settings object, as `app_settings.json` holds it.
AppSettings parseAppSettings(Object? json) =>
    AppSettings.fromJsonFile(json as Map<String, dynamic>);

/// A list of blog posts, as `blog_settings.json` holds it.
List<BlogPageConfig> parseBlogPageConfigs(Object? json) =>
    (json as List<dynamic>)
        .map((e) => BlogPageConfig.fromJsonFile(e as Map<String, dynamic>))
        .toList();

/// A list of media reviews, as `my_two_cents_settings.json` holds it.
List<MyTwoCentsConfig> parseMyTwoCentsConfigs(Object? json) =>
    (json as List<dynamic>)
        .map((e) => MyTwoCentsConfig.fromJsonFile(e as Map<String, dynamic>))
        .toList();
