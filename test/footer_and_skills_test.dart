import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:anthology/Pages/Footer/default_footer_config.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/Pages/Footer/footer_page_config.dart';
import 'package:anthology/Url/external_link_config.dart';
import 'package:anthology/l10n/anthology_localizations.dart';
import 'package:anthology/SocialMedia/Settings/social_media_settings.dart';
import 'package:anthology/Widgets/skill_table.dart';
import 'package:anthology/user_settings.dart';

/// Serves one skills JSON under any key, so SkillTable reads it without the real asset bundle.
class _SkillsBundle extends CachingAssetBundle {
  _SkillsBundle(this.json);

  final String json;

  @override
  Future<ByteData> load(String key) async =>
      ByteData.sublistView(utf8.encode(json));
}

UserSettings _user() => UserSettings(
  socialMediaLinksConfig: const {},
  businessEmail: 'someone@example.org',
  myQuotation: '',
  firstName: 'Some',
  lastName: 'One',
  aboutMeFileDe: 'skills.json',
  aboutMeFileEn: 'skills.json',
  assetPathImgOfMe: '',
);

/// A footer page with only a heading, enough for the footer to lay out its links.
class _FooterPage extends FooterPageConfig {
  _FooterPage(this.heading);

  final String heading;

  @override
  String getHeading(BuildContext context) => heading;

  @override
  String getFilePathEn() => '';

  @override
  String getFilePathDe() => '';

  @override
  String getRoutingName() => '/${heading.hashCode}';
}

/// OmniAccelerANT's seven footer pages, German being the longest; four rows on a desktop.
final List<FooterPageConfig> _footerPages = <FooterPageConfig>[
  for (final String heading in <String>[
    'Impressum',
    'Kontakt',
    'Datenschutz',
    'Cookie Erklärung',
    'Erklärung zur Barrierefreiheit',
    'Urheberrecht',
    'Open-Source-Lizenzen',
  ])
    _FooterPage(heading),
];

/// The real Roboto, so text measures as in an app: the test font's square glyphs overflow rows real text fits.
Future<void> _loadRoboto() async {
  final FontLoader roboto = FontLoader('Roboto');
  for (final String face in <String>['Regular', 'Medium', 'Bold']) {
    roboto.addFont(rootBundle.load('assets/fonts/Roboto/Roboto-$face.ttf'));
  }
  await roboto.load();
}

UserSettings _userWithLinks() => UserSettings(
  socialMediaLinksConfig: <String, ExternalLinkConfig>{
    'GitHub': ExternalLinkConfig(host: 'github.com', path: '/Kataglyphis'),
    'X': ExternalLinkConfig(host: 'x.com', path: '/someone'),
  },
  businessEmail: 'someone@example.org',
  myQuotation: '',
  firstName: 'Some',
  lastName: 'One',
  aboutMeFileDe: 'skills.json',
  aboutMeFileEn: 'skills.json',
  assetPathImgOfMe: '',
);

Future<void> _pumpSkills(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: SkillTable(
            userSettings: _user(),
            aboutMeFile: 'skills.json',
            assetBundle: _SkillsBundle(
              jsonEncode(<String, List<String>>{
                'Programmiersprachen (umfangreiche Erfahrung in Projekten)':
                    <String>['C++', 'Rust'],
              }),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(_loadRoboto);

  test('the copyright runs from 2024 to the current year', () {
    expect(copyrightYears(DateTime(2024, 6)), '2024');
    expect(copyrightYears(DateTime(2026, 10, 12)), '2024–2026');
  });

  test('the social icons stay a const map', () {
    // Icon tree shaking keeps only glyphs it finds in constants: as a final map, six of the seven were stripped.
    expect(
      () => socialMediaIcons['X'] = FontAwesomeIcons.github,
      throwsUnsupportedError,
    );
  });

  // The desktop footer puts this section in a Row of unbounded width, where a Flexible cannot lay out; 200 % text makes that row wider than a desktop, 150 % a phone's links.
  for (final (double width, double textScale) in <(double, double)>[
    (1280, 1),
    (1280, 2),
    (360, 1),
    (360, 1.5),
  ]) {
    testWidgets(
      'the footer lays out at $width px, text x$textScale, icons and liability text included',
      (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = textScale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        addTearDown(tester.view.reset);
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates:
                AnthologyLocalizations.localizationsDelegates,
            supportedLocales: AnthologyLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: Scaffold(
              body: SingleChildScrollView(
                child: Footer(
                  footerPagesConfigs: _footerPages,
                  userSettings: _userWithLinks(),
                  footerConfig: DefaultFooterConfig(),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.byType(FaIcon), findsNWidgets(2));
        expect(find.textContaining('Copyright © '), findsOneWidget);
        expect(find.text('Open-Source-Lizenzen'), findsOneWidget);
      },
    );
  }

  testWidgets('on a phone each skill title stacks above its list', (
    WidgetTester tester,
  ) async {
    await _pumpSkills(tester, 360);
    expect(find.byType(Table), findsNothing);
    expect(find.text('Programmiersprachen'), findsOneWidget);
    expect(find.text('• C++\n• Rust'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('on a wide screen the skills stay a table', (
    WidgetTester tester,
  ) async {
    await _pumpSkills(tester, 1200);
    expect(find.byType(Table), findsOneWidget);
    expect(find.text('• C++\n• Rust'), findsOneWidget);
  });
}
