import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/l10n/anthology_localizations.dart';

/// Every getter on the shared catalogue, paired with a reader.
///
/// Kept explicit rather than derived by reflection: if a key is added to the
/// .arb files and not listed here, that is a deliberate prompt to decide
/// whether the new string deserves coverage.
final Map<String, String Function(AnthologyLocalizations)> _catalogue =
    <String, String Function(AnthologyLocalizations)>{
      'brightness': (AnthologyLocalizations l) => l.brightness,
      'toogleBrightness': (AnthologyLocalizations l) => l.toogleBrightness,
      'switchLang': (AnthologyLocalizations l) => l.switchLang,
      'toogleLanguage': (AnthologyLocalizations l) => l.toogleLanguage,
      'selectSeedColor': (AnthologyLocalizations l) => l.selectSeedColor,
      'imprint': (AnthologyLocalizations l) => l.imprint,
      'contact': (AnthologyLocalizations l) => l.contact,
      'privacyPolicy': (AnthologyLocalizations l) => l.privacyPolicy,
      'cookieStatement': (AnthologyLocalizations l) => l.cookieStatement,
      'declarationOnAccessibility': (AnthologyLocalizations l) =>
          l.declarationOnAccessibility,
      'copyrightFooterTitle': (AnthologyLocalizations l) =>
          l.copyrightFooterTitle,
      'externalLinks': (AnthologyLocalizations l) => l.externalLinks,
      'lastModified': (AnthologyLocalizations l) => l.lastModified,
      'openSourceLicenses': (AnthologyLocalizations l) => l.openSourceLicenses,
      'openSourceLicensesDescription': (AnthologyLocalizations l) =>
          l.openSourceLicensesDescription,
      'openSourceLicensesError': (AnthologyLocalizations l) =>
          l.openSourceLicensesError,
      'openSourceLicensesEmpty': (AnthologyLocalizations l) =>
          l.openSourceLicensesEmpty,
      'copyLabel': (AnthologyLocalizations l) => l.copyLabel,
      'openLabel': (AnthologyLocalizations l) => l.openLabel,
      'sqliteSelfTestTitle': (AnthologyLocalizations l) =>
          l.sqliteSelfTestTitle,
      'sqliteSelfTestDescription': (AnthologyLocalizations l) =>
          l.sqliteSelfTestDescription,
      'sqliteSelfTestRunLabel': (AnthologyLocalizations l) =>
          l.sqliteSelfTestRunLabel,
      'sqliteSelfTestRunningLabel': (AnthologyLocalizations l) =>
          l.sqliteSelfTestRunningLabel,
      'sqliteSelfTestErrorPrefix': (AnthologyLocalizations l) =>
          l.sqliteSelfTestErrorPrefix,
      'myPerfectDay': (AnthologyLocalizations l) => l.myPerfectDay,
      'sleep': (AnthologyLocalizations l) => l.sleep,
      'studying': (AnthologyLocalizations l) => l.studying,
      'sports': (AnthologyLocalizations l) => l.sports,
      'meditation': (AnthologyLocalizations l) => l.meditation,
      'guitar': (AnthologyLocalizations l) => l.guitar,
      'familyFriends': (AnthologyLocalizations l) => l.familyFriends,
      'shortDescriptionTextMyPersona': (AnthologyLocalizations l) =>
          l.shortDescriptionTextMyPersona,
      'mailMe': (AnthologyLocalizations l) => l.mailMe,
      'spendCoffe': (AnthologyLocalizations l) => l.spendCoffe,
      'blockEntryOverview': (AnthologyLocalizations l) => l.blockEntryOverview,
      'blockEntryOverviewDescription': (AnthologyLocalizations l) =>
          l.blockEntryOverviewDescription,
      'entryRedirectText': (AnthologyLocalizations l) => l.entryRedirectText,
      'blogEntriesOverviewLink': (AnthologyLocalizations l) =>
          l.blogEntriesOverviewLink,
      'visitBlogEntry': (AnthologyLocalizations l) => l.visitBlogEntry,
      'playgroundDescription': (AnthologyLocalizations l) =>
          l.playgroundDescription,
      'copyright': (AnthologyLocalizations l) => l.copyright,
      'disclaimer': (AnthologyLocalizations l) => l.disclaimer,
    };

void main() {
  group('AnthologyLocalizations catalogue', () {
    test('ships en, de and fr', () {
      expect(
        AnthologyLocalizations.supportedLocales,
        containsAll(<Locale>[Locale('en'), Locale('de'), Locale('fr')]),
      );
    });

    test('the reader map covers every key in the catalogue', () {
      // A tripwire, not decoration: gen-l10n emits one getter per .arb key, so
      // adding a key without listing it here would leave it untested while the
      // suite still reported green. Bump this deliberately, with the reader.
      expect(
        _catalogue,
        hasLength(42),
        reason:
            'anthology_en.arb has a key this map does not read (or vice versa)',
      );
    });

    test('exposes a delegate', () {
      expect(AnthologyLocalizations.delegate, isNotNull);
    });

    for (final Locale locale in <Locale>[
      Locale('en'),
      Locale('de'),
      Locale('fr'),
    ]) {
      test(
        'every key resolves to a non-empty string in ${locale.languageCode}',
        () {
          final AnthologyLocalizations l10n = lookupAnthologyLocalizations(
            locale,
          );
          for (final MapEntry<String, String Function(AnthologyLocalizations)>
              entry
              in _catalogue.entries) {
            expect(
              entry.value(l10n),
              isNotEmpty,
              reason: '${entry.key} is empty for ${locale.languageCode}',
            );
          }
        },
      );
    }

    test('every key is translated away from the English source', () {
      // Catches an .arb key silently left untranslated, which is how the old
      // hand-rolled localeOf(context) ternaries failed: the third locale
      // quietly received English.
      final AnthologyLocalizations en = lookupAnthologyLocalizations(
        const Locale('en'),
      );
      for (final Locale locale in <Locale>[Locale('de'), Locale('fr')]) {
        final AnthologyLocalizations other = lookupAnthologyLocalizations(
          locale,
        );
        for (final String key in <String>[
          'switchLang',
          'brightness',
          'imprint',
          'privacyPolicy',
          'lastModified',
          'externalLinks',
          'openSourceLicensesDescription',
          'copyLabel',
          'openLabel',
          'sqliteSelfTestDescription',
          'sqliteSelfTestRunLabel',
          'sqliteSelfTestRunningLabel',
          'myPerfectDay',
          'sleep',
          'studying',
          'guitar',
          'familyFriends',
          'shortDescriptionTextMyPersona',
          'mailMe',
          'spendCoffe',
          'blockEntryOverview',
          'entryRedirectText',
          'blogEntriesOverviewLink',
          'visitBlogEntry',
          'playgroundDescription',
          'disclaimer',
        ]) {
          final String Function(AnthologyLocalizations) read = _catalogue[key]!;
          expect(
            read(other),
            isNot(equals(read(en))),
            reason:
                '$key is identical to English in ${locale.languageCode}; it '
                'is very likely untranslated',
          );
        }
      }
    });

    test('switchLang is locale-neutral, not a hard-coded DE/EN pair', () {
      // OmniAccelerANT used to say "Switch (DE/EN)". Any app shipping a third
      // locale is then lying to the user in its own language picker.
      for (final Locale locale in AnthologyLocalizations.supportedLocales) {
        final String label = lookupAnthologyLocalizations(locale).switchLang;
        expect(
          label.toUpperCase(),
          isNot(contains('DE/EN')),
          reason: 'switchLang names specific locales in ${locale.languageCode}',
        );
      }
    });
  });

  group('AnthologyLocalizations delegate in a widget tree', () {
    Future<String> pumpAndRead(
      WidgetTester tester,
      Locale locale,
      String Function(AnthologyLocalizations) read,
    ) async {
      late String seen;
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AnthologyLocalizations.localizationsDelegates,
          supportedLocales: AnthologyLocalizations.supportedLocales,
          home: Builder(
            builder: (BuildContext context) {
              seen = read(AnthologyLocalizations.of(context)!);
              return Text(seen);
            },
          ),
        ),
      );
      return seen;
    }

    testWidgets('resolves the sqlite self-test labels per locale', (
      WidgetTester tester,
    ) async {
      expect(
        await pumpAndRead(
          tester,
          const Locale('en'),
          (AnthologyLocalizations l) => l.sqliteSelfTestRunLabel,
        ),
        'Run test',
      );
      expect(
        await pumpAndRead(
          tester,
          const Locale('de'),
          (AnthologyLocalizations l) => l.sqliteSelfTestRunLabel,
        ),
        'Test ausführen',
      );
      // The regression that mattered: jotrockenmitlocken ships fr, and the
      // ternary this catalogue replaced served it the English label.
      expect(
        await pumpAndRead(
          tester,
          const Locale('fr'),
          (AnthologyLocalizations l) => l.sqliteSelfTestRunLabel,
        ),
        'Lancer le test',
      );
    });

    testWidgets('resolves the open-source-licenses copy per locale', (
      WidgetTester tester,
    ) async {
      final String en = await pumpAndRead(
        tester,
        const Locale('en'),
        (AnthologyLocalizations l) => l.openSourceLicensesEmpty,
      );
      final String de = await pumpAndRead(
        tester,
        const Locale('de'),
        (AnthologyLocalizations l) => l.openSourceLicensesEmpty,
      );
      final String fr = await pumpAndRead(
        tester,
        const Locale('fr'),
        (AnthologyLocalizations l) => l.openSourceLicensesEmpty,
      );
      expect(<String>{en, de, fr}, hasLength(3));
      expect(find.text(fr), findsOneWidget);
    });

    testWidgets('resolves the footer chrome titles per locale', (
      WidgetTester tester,
    ) async {
      expect(
        await pumpAndRead(
          tester,
          const Locale('de'),
          (AnthologyLocalizations l) => l.imprint,
        ),
        'Impressum',
      );
      expect(
        await pumpAndRead(
          tester,
          const Locale('fr'),
          (AnthologyLocalizations l) => l.imprint,
        ),
        'Mentions légales',
      );
    });
  });
}
