import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:anthology/Pages/Footer/default_footer_config.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Pages/Footer/footer_page_config.dart';
import 'package:anthology/Pages/Home/default_home_config.dart';
import 'package:anthology/Pages/navbar_page_config.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';
import 'package:anthology/Routing/router_creater.dart';
import 'package:anthology/Routing/screen_configurations.dart';
import 'package:anthology/app_attributes.dart';
import 'package:anthology/app_settings.dart';
import 'package:anthology/app_shell.dart';
import 'package:anthology/constants.dart';
import 'package:anthology/user_settings.dart';

/// The smallest [ScreenConfigurations] the shell will accept: one page, which
/// doubles as the error page so [RoutesCreator]'s redirect has a target.
class _FakeScreenConfigurations extends ScreenConfigurations {
  static const StatefulBranchInfoProvider _home = _FakeBranchInfo();

  @override
  List<StatefulBranchInfoProvider> getAllPagesConfigs() =>
      <StatefulBranchInfoProvider>[_home];

  @override
  List<StatefulBranchInfoProvider> getErrorPagesConfig() =>
      <StatefulBranchInfoProvider>[_home];

  @override
  List<NavBarPageConfig> getNavRailPagesConfig() => <NavBarPageConfig>[];

  @override
  List<FooterPageConfig> getFooterPagesConfig() => <FooterPageConfig>[];
}

class _FakeBranchInfo extends StatefulBranchInfoProvider {
  const _FakeBranchInfo();

  @override
  String getRoutingName() => '/';
}

/// A [RoutesCreator] that skips the real `Home` chrome.
///
/// [RoutesCreator.getRouterConfig] is overridden with a one-route [GoRouter]
/// whose page reports the locale the shell resolved, which is what these tests
/// are about; building the full navigation shell would only test `Home`.
class _FakeRoutesCreator extends RoutesCreator {
  @override
  List<(Widget, StatefulBranchInfoProvider)> getAllPagesWithConfigs(
    AppAttributes appAttributes,
  ) => <(Widget, StatefulBranchInfoProvider)>[
    (const SizedBox.shrink(), const _FakeBranchInfo()),
  ];

  @override
  Footer getFooter(AppAttributes appAttributes) =>
      throw UnimplementedError('the fake router never builds a footer');

  @override
  GoRouter getRouterConfig(
    AppAttributes appAttributes,
    AnimationController controller,
    void Function(int value) handleChangedPageIndex,
    int currentPageIndex,
  ) {
    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => Text(
            'locale=${Localizations.localeOf(context)}',
            textDirection: TextDirection.ltr,
          ),
        ),
      ],
    );
  }
}

AppSettings _appSettings({List<String>? supportedLocales}) {
  return AppSettings.fromJsonFile(<String, dynamic>{
    'appNameDe': 'AppDe',
    'appNameEn': 'AppEn',
    'appTitleDe': 'TitelDe',
    'appTitleEn': 'TitleEn',
    'disableFooter': false,
    'supportedLocales': ?supportedLocales,
  });
}

UserSettings _userSettings() {
  return UserSettings(
    socialMediaLinksConfig: const {},
    businessEmail: 'someone@example.com',
    myQuotation: 'quote',
    firstName: 'First',
    lastName: 'Last',
    aboutMeFileDe: 'de.md',
    aboutMeFileEn: 'en.md',
    assetPathImgOfMe: 'me.png',
  );
}

/// Builds a shell over [data], capturing the runtime the shell hands out so a
/// test can drive `handle*` exactly like the real UI does.
KataglyphisAppShell<(AppSettings, UserSettings)> _shell(
  Future<(AppSettings, UserSettings)> Function() load, {
  void Function(KataglyphisAppShellRuntime runtime)? onRuntime,
  List<Locale> fallbackLocales = const <Locale>[Locale('en')],
}) {
  return KataglyphisAppShell<(AppSettings, UserSettings)>(
    loadBootstrapData: load,
    fallbackLocales: fallbackLocales,
    buildBinding:
        ((AppSettings, UserSettings) data, KataglyphisAppShellRuntime runtime) {
          onRuntime?.call(runtime);
          return KataglyphisAppShellBinding(
            appAttributes: runtime.buildAppAttributes(
              footerConfig: DefaultFooterConfig(),
              homeConfig: DefaultHomeConfig(),
              appSettings: data.$1,
              userSettings: data.$2,
              screenConfigurations: _FakeScreenConfigurations(),
            ),
            routesCreator: _FakeRoutesCreator(),
          );
        },
  );
}

void main() {
  testWidgets('shows the progress indicator until the loader completes', (
    WidgetTester tester,
  ) async {
    final Completer<(AppSettings, UserSettings)> completer = Completer();

    await tester.pumpWidget(_shell(() => completer.future));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(MaterialApp), findsNothing);

    completer.complete((
      _appSettings(supportedLocales: <String>['en', 'de']),
      _userSettings(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('locale=en'), findsOneWidget);
  });

  testWidgets('the loader runs exactly once across rebuilds', (
    WidgetTester tester,
  ) async {
    int calls = 0;
    late KataglyphisAppShellRuntime seen;
    Future<(AppSettings, UserSettings)> load() async {
      calls++;
      return (
        _appSettings(supportedLocales: <String>['en', 'de']),
        _userSettings(),
      );
    }

    await tester.pumpWidget(
      _shell(load, onRuntime: (KataglyphisAppShellRuntime r) => seen = r),
    );
    await tester.pumpAndSettle();
    expect(calls, 1);

    // Any setState on the shell rebuilds the FutureBuilder; a future recreated
    // in build() would restart the load and flash the spinner again.
    seen.handleColorSelect(ColorSeed.pink.index);
    await tester.pumpAndSettle();
    expect(calls, 1);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('handleLanguageSelect moves MaterialApp.locale', (
    WidgetTester tester,
  ) async {
    late KataglyphisAppShellRuntime seen;

    await tester.pumpWidget(
      _shell(
        () async => (
          _appSettings(supportedLocales: <String>['en', 'de']),
          _userSettings(),
        ),
        onRuntime: (KataglyphisAppShellRuntime runtime) => seen = runtime,
      ),
    );
    await tester.pumpAndSettle();

    MaterialApp app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('en'));
    expect(find.text('locale=en'), findsOneWidget);

    // Was ineffective while OmniAccelerANT pinned `locale: supportedLanguages[0]`.
    seen.handleLanguageSelect(1);
    await tester.pumpAndSettle();

    app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.locale, const Locale('de'));
    expect(find.text('locale=de'), findsOneWidget);
    // onGenerateTitle follows the same locale, which is what the pin broke.
    expect(
      app.onGenerateTitle!(tester.element(find.text('locale=de'))),
      'TitelDe',
    );
  });

  testWidgets('a missing supportedLocales falls back instead of crashing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _shell(() async => (_appSettings(), _userSettings())),
    );
    await tester.pumpAndSettle();

    final MaterialApp app = tester.widget<MaterialApp>(
      find.byType(MaterialApp),
    );
    expect(app.supportedLocales, const <Locale>[Locale('en')]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the failure screen renders the error and does not throw', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _shell(() async => throw const FormatException('bad settings json')),
    );
    await tester.pumpAndSettle();

    // A bare Material subtree here has no Directionality ancestor and throws
    // while reporting the error; the MaterialApp wrapper is what fixes that.
    expect(tester.takeException(), isNull);
    expect(find.text('Failed to load application settings'), findsOneWidget);
    expect(find.textContaining('bad settings json'), findsOneWidget);
  });

  testWidgets('the width breakpoints drive the layout flags it hands over', (
    WidgetTester tester,
  ) async {
    late KataglyphisAppShellRuntime seen;
    Widget shell() => _shell(
      () async =>
          (_appSettings(supportedLocales: <String>['en']), _userSettings()),
      onRuntime: (KataglyphisAppShellRuntime runtime) => seen = runtime,
    );

    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(shell());
    await tester.pumpAndSettle();
    expect(seen.showMediumSizeLayout, isFalse);
    expect(seen.showLargeSizeLayout, isFalse);

    tester.view.physicalSize = const Size(1200, 600);
    await tester.pumpAndSettle();
    expect(seen.showMediumSizeLayout, isTrue);
    expect(seen.showLargeSizeLayout, isFalse);

    tester.view.physicalSize = const Size(1600, 600);
    await tester.pumpAndSettle();
    expect(seen.showMediumSizeLayout, isFalse);
    expect(seen.showLargeSizeLayout, isTrue);
  });
}
