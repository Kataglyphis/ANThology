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
import 'package:anthology/app_attributes_scope.dart';
import 'package:anthology/app_settings.dart';
import 'package:anthology/app_shell.dart';
import 'package:anthology/constants.dart';
import 'package:anthology/user_settings.dart';

/// One page that doubles as the error page, so [RoutesCreator]'s redirect has a target.
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

/// A one-route [GoRouter] whose page reports the locale the shell resolved, skipping `Home`.
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

  /// Routers made so far, across instances: each new one drops every page's state.
  static int routersBuilt = 0;

  @override
  GoRouter getRouterConfig(
    AppAttributes appAttributes,
    AnimationController controller,
    void Function(int value) handleChangedPageIndex,
    int currentPageIndex,
  ) {
    routersBuilt++;
    return GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => Material(
            child: Column(
              children: [
                Text('locale=${Localizations.localeOf(context)}'),
                Text(
                  'seed=${AppAttributesScope.maybeOf(context)?.colorSelected.name}',
                ),
                const TextField(key: ValueKey('draft')),
              ],
            ),
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

/// Builds a shell and captures its runtime, so a test can drive `handle*` like the real UI.
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
  testWidgets(
    'appearance changes keep a routed form and publish current attributes',
    (tester) async {
      late KataglyphisAppShellRuntime runtime;
      tester.view.physicalSize = const Size(800, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _shell(
          () async =>
              (_appSettings(supportedLocales: ['en', 'de']), _userSettings()),
          onRuntime: (value) => runtime = value,
        ),
      );
      await tester.pumpAndSettle();
      final router = GoRouter.of(
        tester.element(find.byKey(const ValueKey('draft'))),
      );
      final state = tester.state(find.byType(EditableText));
      await tester.enterText(find.byType(TextField), 'unsaved camera name');
      runtime.handleBrightnessChange(true);
      await tester.pumpAndSettle();
      runtime.handleColorSelect(ColorSeed.pink.index);
      await tester.pumpAndSettle();
      runtime.handleLanguageSelect(1);
      await tester.pumpAndSettle();
      tester.view.physicalSize = const Size(1600, 900);
      await tester.pumpAndSettle();
      expect(GoRouter.of(tester.element(find.byType(TextField))), same(router));
      expect(tester.state(find.byType(EditableText)), same(state));
      expect(find.text('unsaved camera name'), findsOneWidget);
      expect(find.text('locale=de'), findsOneWidget);
      expect(find.text('seed=pink'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets(
    'a resize within a breakpoint or an open keyboard keeps the router and its pages',
    (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1100, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _shell(
          () async =>
              (_appSettings(supportedLocales: <String>['en']), _userSettings()),
        ),
      );
      await tester.pumpAndSettle();
      final int before = _FakeRoutesCreator.routersBuilt;

      tester.view.physicalSize = const Size(1180, 640);
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pumpAndSettle();
      expect(_FakeRoutesCreator.routersBuilt, before);

      // The layout updates without discarding routed page state.
      tester.view.physicalSize = const Size(1600, 700);
      await tester.pumpAndSettle();
      expect(_FakeRoutesCreator.routersBuilt, before);
    },
  );

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

    // A setState rebuilds the FutureBuilder; a future recreated in build() would restart the load.
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

    // A bare Material here has no Directionality ancestor and would throw while reporting.
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
