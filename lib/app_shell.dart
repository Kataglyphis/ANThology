import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:anthology/Pages/Footer/footer_config.dart';
import 'package:anthology/Pages/Home/home_config.dart';
import 'package:anthology/Routing/router_creater.dart';
import 'package:anthology/Routing/screen_configurations.dart';
import 'package:anthology/app_attributes.dart';
import 'package:anthology/app_settings.dart';
import 'package:anthology/constants.dart';
import 'package:anthology/l10n/anthology_localizations.dart';
import 'package:anthology/user_settings.dart';

/// Default font family; package fonts register under the `packages/<name>/` prefix.
const String kAppShellFontFamily = 'packages/anthology/Roboto';

/// Loads everything an app needs before its first frame; called once, from the shell's `initState`.
typedef AppShellDataLoader<T> = Future<T> Function();

/// Turns the loaded `T` into the two objects the shared tail needs.
/// One callback, not two: both objects derive from one intermediate, app-owned value.
typedef AppShellBindingBuilder<T> =
    KataglyphisAppShellBinding Function(
      T data,
      KataglyphisAppShellRuntime runtime,
    );

/// Builds the screen shown while [AppShellDataLoader] is still running.
typedef AppShellLoadingBuilder = Widget Function(BuildContext context);

/// Builds the screen shown when [AppShellDataLoader] failed.
typedef AppShellErrorBuilder =
    Widget Function(
      BuildContext context,
      Object? error,
      StackTrace? stackTrace,
    );

/// The shell-owned state an app needs to build its own [AppAttributes], subclass included.
/// Apps that need nothing special call [buildAppAttributes].
@immutable
class KataglyphisAppShellRuntime {
  const KataglyphisAppShellRuntime({
    required this.railAnimation,
    required this.showMediumSizeLayout,
    required this.showLargeSizeLayout,
    required this.currentLanguageIndex,
    required this.useLightMode,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleLanguageSelect,
    required this.handleColorSelect,
  });

  /// Drives the navigation rail's reveal; owned by the shell's controller.
  final CurvedAnimation railAnimation;

  /// True between [mediumWidthBreakpoint] and [largeWidthBreakpoint].
  final bool showMediumSizeLayout;

  /// True above [largeWidthBreakpoint].
  final bool showLargeSizeLayout;

  /// Index into the app's supported locales, moved by [handleLanguageSelect].
  final int currentLanguageIndex;

  /// Resolved from the shell's [ThemeMode] and the platform brightness.
  final bool useLightMode;

  /// The seed colour the theme is built from.
  final ColorSeed colorSelected;

  /// Switches the shell between [ThemeMode.light] and [ThemeMode.dark].
  final void Function(bool useLightMode) handleBrightnessChange;

  /// Selects the locale at `index`; the shell rebuilds with it.
  final void Function(int index) handleLanguageSelect;

  /// Selects [ColorSeed] `values[value]`; the shell rebuilds both themes.
  final void Function(int value) handleColorSelect;

  /// Fills the shell-owned half of an [AppAttributes]; the app supplies the rest.
  AppAttributes buildAppAttributes({
    required FooterConfig footerConfig,
    required HomeConfig homeConfig,
    required AppSettings appSettings,
    required UserSettings userSettings,
    required ScreenConfigurations screenConfigurations,
  }) {
    return AppAttributes(
      footerConfig: footerConfig,
      homeConfig: homeConfig,
      appSettings: appSettings,
      userSettings: userSettings,
      screenConfigurations: screenConfigurations,
      railAnimation: railAnimation,
      showMediumSizeLayout: showMediumSizeLayout,
      showLargeSizeLayout: showLargeSizeLayout,
      currentLanguageIndex: currentLanguageIndex,
      useLightMode: useLightMode,
      colorSelected: colorSelected,
      handleBrightnessChange: handleBrightnessChange,
      handleLanguageSelect: handleLanguageSelect,
      handleColorSelect: handleColorSelect,
    );
  }
}

/// What an app hands back from its [AppShellBindingBuilder].
@immutable
class KataglyphisAppShellBinding {
  const KataglyphisAppShellBinding({
    required this.appAttributes,
    required this.routesCreator,
  });

  /// Everything the shared pages read.
  final AppAttributes appAttributes;

  /// The app's route table; the shell calls [RoutesCreator.getRouterConfig] on it.
  final RoutesCreator routesCreator;
}

/// The application shell both Kataglyphis Flutter apps are built on.
/// The apps supply only how they load settings and which app-owned types those become.
class KataglyphisAppShell<T> extends StatefulWidget {
  const KataglyphisAppShell({
    super.key,
    required this.loadBootstrapData,
    required this.buildBinding,
    this.appLocalizationsDelegates = const <LocalizationsDelegate<dynamic>>[],
    this.fontFamily = kAppShellFontFamily,
    this.initialThemeMode = ThemeMode.dark,
    this.initialColorSeed = ColorSeed.baseColor,
    this.fallbackLocales = const <Locale>[Locale('en')],
    this.loadingBuilder,
    this.errorBuilder,
  });

  /// Runs once, from `initState`.
  final AppShellDataLoader<T> loadBootstrapData;

  /// Turns the loaded data into an [AppAttributes] and a [RoutesCreator].
  final AppShellBindingBuilder<T> buildBinding;

  /// The app's own delegates; the shell appends [AnthologyLocalizations.delegate] and the `Global*Localizations` ones.
  final List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates;

  /// Font family for both generated themes.
  final String fontFamily;

  /// Theme mode before the user touches the brightness switch.
  final ThemeMode initialThemeMode;

  /// Seed colour before the user touches the colour menu.
  final ColorSeed initialColorSeed;

  /// Used when `AppSettings.supportedLocales` is null or empty; must not be empty itself.
  final List<Locale> fallbackLocales;

  /// Overrides the default progress indicator.
  final AppShellLoadingBuilder? loadingBuilder;

  /// Overrides the default failure screen.
  final AppShellErrorBuilder? errorBuilder;

  @override
  State<KataglyphisAppShell<T>> createState() => _KataglyphisAppShellState<T>();
}

class _KataglyphisAppShellState<T> extends State<KataglyphisAppShell<T>>
    with SingleTickerProviderStateMixin {
  late ThemeMode themeMode = widget.initialThemeMode;
  late ColorSeed colorSelected = widget.initialColorSeed;
  int currentLanguageIndex = 0;
  int currentPageIndex = 0;

  late final AnimationController controller;
  late final CurvedAnimation railAnimation;
  late final Future<T> _bootstrapData;

  bool controllerInitialized = false;
  bool showMediumSizeLayout = false;
  bool showLargeSizeLayout = false;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return View.of(context).platformDispatcher.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  late final List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    ...widget.appLocalizationsDelegates,
    // Without it AnthologyLocalizations.of(context) is null and every package page throws.
    AnthologyLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: transitionLength.toInt() * 2),
      value: 0,
      vsync: this,
    );
    railAnimation = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.5, 1.0),
    );
    _bootstrapData = widget.loadBootstrapData();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = controller.status;
    if (width > mediumWidthBreakpoint) {
      if (width > largeWidthBreakpoint) {
        showMediumSizeLayout = false;
        showLargeSizeLayout = true;
      } else {
        showMediumSizeLayout = true;
        showLargeSizeLayout = false;
      }
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        controller.forward();
      }
    } else {
      showMediumSizeLayout = false;
      showLargeSizeLayout = false;
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      controller.value = width > mediumWidthBreakpoint ? 1 : 0;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void handlePageChange(int pageIndex) {
    currentPageIndex = pageIndex;
  }

  void handleLanguageSelect(int index) {
    setState(() {
      currentLanguageIndex = index;
    });
  }

  void handleColorSelect(int value) {
    setState(() {
      colorSelected = ColorSeed.values[value];
    });
  }

  /// The app's declared locales, or [KataglyphisAppShell.fallbackLocales] when there are none.
  List<Locale> _supportedLocales(AppSettings appSettings) {
    final List<Locale> supportedLanguages =
        (appSettings.supportedLocales ?? const <String>[])
            .map((element) => Locale(element))
            .toList();
    if (supportedLanguages.isEmpty) {
      return List<Locale>.of(widget.fallbackLocales);
    }
    return supportedLanguages;
  }

  Widget _buildLoading(BuildContext context) {
    final AppShellLoadingBuilder? builder = widget.loadingBuilder;
    if (builder != null) {
      return builder(context);
    }
    return Center(
      child: CircularProgressIndicator(color: widget.initialColorSeed.color),
    );
  }

  Widget _buildError(BuildContext context, Object? error, StackTrace? stack) {
    final AppShellErrorBuilder? builder = widget.errorBuilder;
    if (builder != null) {
      return builder(context, error, stack);
    }
    // A MaterialApp: nothing above supplies a Directionality, so a bare Material would throw.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                const SizedBox(height: 16),
                const Text(
                  'Failed to load application settings',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '$error',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData(
      fontFamily: widget.fontFamily,
      colorSchemeSeed: colorSelected.color,
      useMaterial3: true,
      brightness: Brightness.dark,
    );
    final ThemeData lightTheme = ThemeData(
      fontFamily: widget.fontFamily,
      colorSchemeSeed: colorSelected.color,
      useMaterial3: true,
      brightness: Brightness.light,
    );
    return FutureBuilder<T>(
      future: _bootstrapData,
      builder: (BuildContext context, AsyncSnapshot<T> data) {
        if (data.hasData) {
          final KataglyphisAppShellBinding binding = widget.buildBinding(
            data.requireData,
            KataglyphisAppShellRuntime(
              railAnimation: railAnimation,
              showMediumSizeLayout: showMediumSizeLayout,
              showLargeSizeLayout: showLargeSizeLayout,
              currentLanguageIndex: currentLanguageIndex,
              useLightMode: useLightMode,
              colorSelected: colorSelected,
              handleBrightnessChange: handleBrightnessChange,
              handleLanguageSelect: handleLanguageSelect,
              handleColorSelect: handleColorSelect,
            ),
          );
          final AppAttributes appAttributes = binding.appAttributes;

          final GoRouter routerConfig = binding.routesCreator.getRouterConfig(
            appAttributes,
            controller,
            handlePageChange,
            currentPageIndex,
          );
          final List<Locale> supportedLanguages = _supportedLocales(
            appAttributes.appSettings,
          );
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: localizationsDelegates,
            onGenerateTitle: (BuildContext context) =>
                (Localizations.localeOf(context) == const Locale("de"))
                ? appAttributes.appSettings.appTitleDe
                : appAttributes.appSettings.appTitleEn,
            themeMode: themeMode,
            // Follows the selection; a pinned locale leaves onGenerateTitle on the first language.
            locale:
                supportedLanguages[currentLanguageIndex %
                    supportedLanguages.length],
            supportedLocales: supportedLanguages,
            theme: lightTheme,
            darkTheme: darkTheme,
            routerConfig: routerConfig,
          );
        } else if (data.hasError) {
          return _buildError(context, data.error, data.stackTrace);
        } else {
          return _buildLoading(context);
        }
      },
    );
  }
}
