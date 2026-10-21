import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anthology/locale_helpers.dart';
import 'package:anthology/user_settings.dart';

/// What [localizedValue] picks under [locale].
Future<String> _pick(WidgetTester tester, Locale locale) async {
  late String picked;
  await tester.pumpWidget(
    Localizations(
      locale: locale,
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultWidgetsLocalizations.delegate,
      ],
      child: Builder(
        builder: (BuildContext context) {
          picked = localizedValue(context, de: 'Katze', en: 'cat');
          return const SizedBox();
        },
      ),
    ),
  );
  return picked;
}

void main() {
  testWidgets('German picks the German value, English the English one', (
    WidgetTester tester,
  ) async {
    expect(await _pick(tester, const Locale('de')), 'Katze');
    expect(await _pick(tester, const Locale('en')), 'cat');
  });

  testWidgets('a German locale with a country is German too', (
    WidgetTester tester,
  ) async {
    expect(await _pick(tester, const Locale('de', 'AT')), 'Katze');
    expect(await _pick(tester, const Locale('de', 'CH')), 'Katze');
    expect(await _pick(tester, const Locale('fr')), 'cat');
  });

  group('UserSettings.aboutMeFileFor', () {
    final UserSettings settings = UserSettings(
      socialMediaLinksConfig: null,
      businessEmail: null,
      myQuotation: null,
      firstName: 'A',
      lastName: 'B',
      aboutMeFileDe: 'de.json',
      aboutMeFileEn: 'en.json',
      aboutMeFileFr: 'fr.json',
      assetPathImgOfMe: null,
    );

    test('picks by language, whatever the country', () {
      expect(settings.aboutMeFileFor(const Locale('de')), 'de.json');
      expect(settings.aboutMeFileFor(const Locale('de', 'AT')), 'de.json');
      expect(settings.aboutMeFileFor(const Locale('fr', 'CA')), 'fr.json');
      expect(settings.aboutMeFileFor(const Locale('en', 'GB')), 'en.json');
      expect(settings.aboutMeFileFor(const Locale('es')), 'en.json');
    });

    test('a language without its own file gets English', () {
      settings.aboutMeFileFr = null;
      expect(settings.aboutMeFileFor(const Locale('fr')), 'en.json');
    });
  });
}
