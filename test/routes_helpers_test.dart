import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Pages/ErrorPage/error_page.dart';
import 'package:anthology/Pages/ErrorPage/error_page_stateful_branch_info_provider.dart';
import 'package:anthology/Pages/Footer/default_footer_config.dart';
import 'package:anthology/Pages/Footer/default_footer_pages.dart';
import 'package:anthology/Pages/Footer/footer_page.dart';
import 'package:anthology/Pages/Footer/footer_page_config.dart';
import 'package:anthology/Pages/Footer/open_source_licenses_page.dart';
import 'package:anthology/Pages/Home/default_home_config.dart';
import 'package:anthology/Pages/blog_dependent_screen_configurations.dart';
import 'package:anthology/Pages/navbar_page_config.dart';
import 'package:anthology/Pages/simple_page_config.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';
import 'package:anthology/Routing/router_creater.dart';
import 'package:anthology/Routing/screen_configurations.dart';
import 'package:anthology/app_attributes.dart';
import 'package:anthology/app_settings.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/constants.dart';
import 'package:anthology/my_two_cents_config.dart';
import 'package:anthology/user_settings.dart';

class _Screens extends ScreenConfigurations
    with BlogDependentScreenConfigurations {
  @override
  List<StatefulBranchInfoProvider> getErrorPagesConfig() =>
      <StatefulBranchInfoProvider>[ErrorPageStatefulBranchInfoProvider()];
  @override
  List<NavBarPageConfig> getNavRailPagesConfig() => <NavBarPageConfig>[];
  @override
  List<FooterPageConfig> getFooterPagesConfig() => defaultFooterPageConfigs();
  @override
  List<BlogPageConfig> getBlogPagesConfig() => <BlogPageConfig>[];
  @override
  List<MyTwoCentsConfig> getMediaCriticsPagesConfig() => <MyTwoCentsConfig>[];
  @override
  List<StatefulBranchInfoProvider> getDataPagesConfig() =>
      <StatefulBranchInfoProvider>[const SimplePageConfig('/data')];
}

class _Routes extends RoutesCreator {
  @override
  List<(Widget, StatefulBranchInfoProvider)> getAllPagesWithConfigs(
    AppAttributes appAttributes,
  ) => <(Widget, StatefulBranchInfoProvider)>[
    ...footerPagesWithConfigs(appAttributes),
    ...errorPagesWithConfigs(appAttributes),
  ];
}

void main() {
  late AnimationController controller;
  late AppAttributes appAttributes;

  setUp(() {
    controller = AnimationController(vsync: const TestVSync());
    appAttributes = AppAttributes(
      footerConfig: DefaultFooterConfig(),
      homeConfig: DefaultHomeConfig(),
      appSettings: AppSettings(
        appNameDe: 'De',
        appNameEn: 'En',
        appTitleDe: 'De',
        appTitleEn: 'En',
        disableFooter: false,
      ),
      userSettings: UserSettings(
        socialMediaLinksConfig: null,
        businessEmail: null,
        myQuotation: null,
        firstName: 'A',
        lastName: 'B',
        aboutMeFileDe: 'de.json',
        aboutMeFileEn: 'en.json',
        assetPathImgOfMe: null,
      ),
      screenConfigurations: _Screens(),
      railAnimation: CurvedAnimation(parent: controller, curve: Curves.linear),
      showMediumSizeLayout: false,
      showLargeSizeLayout: false,
      colorSelected: ColorSeed.baseColor,
      useLightMode: true,
    );
  });

  tearDown(() => controller.dispose());

  test('the licence route gets the licence page, the others Markdown', () {
    final pages = _Routes().footerPagesWithConfigs(appAttributes);
    expect(pages, hasLength(7));
    for (final (Widget page, StatefulBranchInfoProvider config) in pages) {
      expect(
        page,
        config.getRoutingName() == openSourceLicensesRoute
            ? isA<OpenSourceLicensesPage>()
            : isA<FooterPage>(),
        reason: config.getRoutingName(),
      );
    }
  });

  test('one error page per error config', () {
    final pages = _Routes().errorPagesWithConfigs(appAttributes);
    expect(pages.single.$1, isA<ErrorPage>());
    expect(pages.single.$2, isA<ErrorPageStatefulBranchInfoProvider>());
  });

  test('the screen list holds every page the router serves', () {
    final routes = appAttributes.screenConfigurations.getAllValidRoutes();
    expect(routes, contains('/imprint'));
    expect(routes, contains(openSourceLicensesRoute));
    expect(routes, contains('/data'));
    expect(
      routes,
      contains(ErrorPageStatefulBranchInfoProvider().getRoutingName()),
    );
  });

  test('pairing refuses lists of different length', () {
    expect(
      () => _Routes().pairPagesWithConfigs(
        <Widget>[],
        <StatefulBranchInfoProvider>[const SimplePageConfig('/x')],
      ),
      throwsA(isA<AssertionError>()),
    );
  });
}
