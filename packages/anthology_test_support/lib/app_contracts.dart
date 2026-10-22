import 'package:anthology/Pages/ErrorPage/error_page.dart';
import 'package:anthology/Testing/real_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

const List<(Size, double)> appLayoutCases = <(Size, double)>[
  (Size(360, 800), 1),
  (Size(800, 1000), 1),
  (Size(1280, 900), 1),
  (Size(360, 800), 1.5),
  (Size(360, 800), 2),
  (Size(1280, 900), 2),
];

Future<void> _waitForAssets(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 500)),
  );
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _mount(WidgetTester tester, Widget Function() app) async {
  await tester.runAsync(() async {
    await tester.pumpWidget(app());
    await Future<void>.delayed(const Duration(seconds: 1));
  });
  await _waitForAssets(tester);
  expect(find.byType(Scaffold), findsWidgets);
}

GoRouter _router(WidgetTester tester) =>
    GoRouter.of(tester.element(find.byType(Scaffold).first));

Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  // Markdown visibility detectors finish their pending interval after unmount.
  await tester.pump(const Duration(seconds: 1));
}

/// Registers the same route, width and text-scale contract for each consumer.
void registerAppLayoutTests({
  required Widget Function() app,
  required List<String> routes,
  List<(Size, double)> cases = appLayoutCases,
}) {
  setUpAll(loadAnthologyFonts);
  for (final (size, textScale) in cases) {
    testWidgets(
      'every main page lays out at ${size.width.toInt()}x${size.height.toInt()}, text x$textScale',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = textScale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        addTearDown(tester.view.reset);
        await _mount(tester, app);
        for (final route in routes) {
          final router = _router(tester)..go(route);
          await _waitForAssets(tester);
          expect(tester.takeException(), isNull, reason: route);
          expect(router.routerDelegate.currentConfiguration.uri.path, route);
          expect(find.byType(ErrorPage), findsNothing, reason: route);
        }
        await _unmount(tester);
      },
    );
  }
}

/// Exercises real navigation and appearance buttons without replacing the router.
void registerAppNavigationContract({
  required Widget Function() app,
  required int navigationIndex,
  required String route,
}) {
  testWidgets(
    'bottom navigation survives theme, language and breakpoint changes',
    (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await _mount(tester, app);
      final router = _router(tester);
      final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      final destination =
          bar.destinations[navigationIndex] as NavigationDestination;
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(destination.label),
        ),
      );
      await _waitForAssets(tester);
      expect(router.routerDelegate.currentConfiguration.uri.path, route);

      final beforeTheme = tester
          .widget<MaterialApp>(find.byType(MaterialApp))
          .themeMode;
      await tester.tap(
        find.byIcon(Icons.light_mode_outlined).hitTestable().first,
      );
      await _waitForAssets(tester);
      expect(identical(_router(tester), router), isTrue);
      expect(router.routerDelegate.currentConfiguration.uri.path, route);
      expect(
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        isNot(beforeTheme),
      );

      final beforeLanguage = tester.widget<MaterialApp>(
        find.byType(MaterialApp),
      );
      final nextLocale = beforeLanguage.supportedLocales.firstWhere(
        (locale) => locale.languageCode != beforeLanguage.locale!.languageCode,
      );
      await tester.tap(find.byIcon(Icons.translate).hitTestable().first);
      // Animated page content can keep scheduling frames while the menu is usable.
      await _waitForAssets(tester);
      await tester.tap(
        find.text(nextLocale.languageCode.toUpperCase()).hitTestable().last,
      );
      await _waitForAssets(tester);
      expect(identical(_router(tester), router), isTrue);
      expect(router.routerDelegate.currentConfiguration.uri.path, route);
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, nextLocale);

      tester.view.physicalSize = const Size(1600, 900);
      await _waitForAssets(tester);
      expect(identical(_router(tester), router), isTrue);
      expect(router.routerDelegate.currentConfiguration.uri.path, route);
      expect(tester.takeException(), isNull);
      await _unmount(tester);
    },
  );
}
