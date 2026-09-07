import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Pages/Footer/footer_config.dart';
import 'package:anthology/Pages/Home/button_names.dart';
import 'package:anthology/Pages/Home/home_config.dart';
import 'package:anthology/Pages/Footer/footer_page_config.dart';
import 'package:anthology/Pages/markdown_content_page.dart';
import 'package:anthology/Pages/navbar_page_config.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';
import 'package:anthology/Routing/screen_configurations.dart';
import 'package:anthology/Url/external_link_config.dart';
import 'package:anthology/app_attributes.dart';
import 'package:anthology/app_settings.dart';
import 'package:anthology/constants.dart';
import 'package:anthology/user_settings.dart';

class _TestFooterConfig extends FooterConfig {
  @override
  String getLiabilityText(BuildContext context) => 'liability';
  @override
  String getExternalLinksTitle(BuildContext context) => 'links';
  @override
  List<ExternalLinkConfig> getExternalLinks(BuildContext context) => [];
}

class _TestHomeConfig extends HomeConfig {
  @override
  ButtonNames getButtonNames(BuildContext context) => ButtonNames();
}

class _TestScreenConfigurations extends ScreenConfigurations {
  @override
  List<StatefulBranchInfoProvider> getAllPagesConfigs() => [];
  @override
  List<StatefulBranchInfoProvider> getErrorPagesConfig() => [];
  @override
  List<NavBarPageConfig> getNavRailPagesConfig() => [];
  @override
  List<FooterPageConfig> getFooterPagesConfig() => [];
}

class _TestMarkdownContentConfig implements MarkdownContentConfig {
  @override
  final String filePath = 'assets/documents/blog/entry.md';
  @override
  final String imageDir = 'assets/images/blog';
  @override
  final List<Map<String, String>> docsDesc = [
    {'baseDir': 'assets/data', 'title': 'Sheet', 'additionalInfo': 'csv'},
  ];
}

void main() {
  late AppAttributes appAttributes;
  late Footer footer;
  late AnimationController animationController;

  setUp(() {
    animationController = AnimationController(vsync: const TestVSync());
    final userSettings = UserSettings(
      socialMediaLinksConfig: <String, ExternalLinkConfig>{},
      businessEmail: 'test@example.com',
      myQuotation: 'Hello',
      firstName: 'Jane',
      lastName: 'Doe',
      aboutMeFileDe: 'about_de.md',
      aboutMeFileEn: 'about_en.md',
      assetPathImgOfMe: 'img.jpg',
    );
    final footerConfig = _TestFooterConfig();
    footer = Footer(
      footerPagesConfigs: const [],
      userSettings: userSettings,
      footerConfig: footerConfig,
    );
    appAttributes = AppAttributes(
      footerConfig: footerConfig,
      homeConfig: _TestHomeConfig(),
      appSettings: AppSettings(
        appNameDe: 'TestDE',
        appNameEn: 'TestEN',
        appTitleDe: 'TitleDE',
        appTitleEn: 'TitleEN',
        disableFooter: false,
      ),
      userSettings: userSettings,
      screenConfigurations: _TestScreenConfigurations(),
      railAnimation: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
      showMediumSizeLayout: false,
      showLargeSizeLayout: false,
      colorSelected: ColorSeed.baseColor,
      useLightMode: true,
    );
  });

  tearDown(() {
    animationController.dispose();
  });

  group('MarkdownContentPage', () {
    test('hands back the config it was given', () {
      final config = _TestMarkdownContentConfig();
      final page = MarkdownContentPage(
        appAttributes: appAttributes,
        footer: footer,
        config: config,
      );

      expect(page.config, same(config));
      expect(page.appendixTitle, 'Appendix');
    });

    test('appendixTitle is overridable', () {
      final page = MarkdownContentPage(
        appAttributes: appAttributes,
        footer: footer,
        config: _TestMarkdownContentConfig(),
        appendixTitle: 'References',
      );

      expect(page.appendixTitle, 'References');
    });

    test('deprecated loose-parameter constructor still resolves a config', () {
      // Deliberately exercises the deprecated pre-1.2 signature: this package
      // is published, so the passthrough must keep working until it is removed.
      final page = MarkdownContentPage(
        appAttributes: appAttributes,
        footer: footer,
        filePath: 'assets/documents/blog/legacy.md',
        imageDir: 'assets/images/legacy',
        docsDesc: const [
          {
            'baseDir': 'assets/data',
            'title': 'Legacy',
            'additionalInfo': 'pdf',
          },
        ],
      );

      expect(page.config.filePath, 'assets/documents/blog/legacy.md');
      expect(page.config.imageDir, 'assets/images/legacy');
      expect(page.config.docsDesc, hasLength(1));
      expect(page.config.docsDesc.single['title'], 'Legacy');
    });

    test('deprecated constructor tolerates an omitted docsDesc', () {
      final page = MarkdownContentPage(
        appAttributes: appAttributes,
        footer: footer,
        filePath: 'assets/documents/blog/legacy.md',
        imageDir: 'assets/images/legacy',
      );

      expect(page.config.docsDesc, isEmpty);
    });

    test('refuses a construction that supplies neither form', () {
      expect(
        () => MarkdownContentPage(appAttributes: appAttributes, footer: footer),
        throwsA(isA<AssertionError>()),
      );
    });

    test('refuses a construction that mixes both forms', () {
      expect(
        () => MarkdownContentPage(
          appAttributes: appAttributes,
          footer: footer,
          config: _TestMarkdownContentConfig(),
          filePath: 'assets/documents/blog/legacy.md',
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
