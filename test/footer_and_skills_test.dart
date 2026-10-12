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

  // The desktop footer puts this section in a Row of unbounded width, where a Flexible cannot lay out.
  for (final double width in <double>[1280, 360]) {
    testWidgets(
      'the footer lays out at $width px, icons and liability text included',
      (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
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
                  footerPagesConfigs: const <FooterPageConfig>[],
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
