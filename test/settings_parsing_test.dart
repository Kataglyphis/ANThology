// The settings readers both sites boot from: a missing or mistyped field must name itself, not render a blank page.
import 'package:anthology/app_settings.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/json_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

/// A blog entry with every required field, as blog_settings.json carries one.
Map<String, dynamic> _blogEntry() => <String, dynamic>{
  'routingName': '/aiBlog',
  'shortDescriptionEN': 'AI',
  'shortDescriptionDE': 'KI',
  'filePath': 'packages/anthology/assets/documents/blog/aiBlogPageEn.md',
  'imageDir': 'packages/anthology/assets/images/',
  'githubRepo': 'https://github.com/Kataglyphis',
  'landingPageAlignment': 'left',
  'landingPageEntryImagePath': 'a.webp',
  'lastModified': '2026-10-15',
  'fileTitle': 'AI',
  'fileAdditionalInfo': '',
  'fileBaseDir': 'packages/anthology/assets/documents/blog/',
};

void main() {
  group('requireStringField', () {
    test('returns the string', () {
      expect(requireStringField(<String, dynamic>{'a': 'x'}, 'a'), 'x');
    });

    test('names a missing field', () {
      expect(
        () => requireStringField(<String, dynamic>{}, 'routingName'),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Missing required field: routingName',
          ),
        ),
      );
    });

    test('names a field of the wrong type and the type it had', () {
      expect(
        () => requireStringField(<String, dynamic>{'n': 3}, 'n'),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Field "n" must be a String, got int',
          ),
        ),
      );
    });
  });

  group('parseDocsDesc', () {
    test('null is no appendix', () {
      expect(parseDocsDesc(null), isEmpty);
    });

    test('a non-list is refused', () {
      expect(() => parseDocsDesc(<String, dynamic>{}), throwsFormatException);
    });

    test(
      'keeps the objects, fills their missing keys and skips anything else',
      () {
        expect(
          parseDocsDesc(<dynamic>[
            <String, dynamic>{
              'baseDir': 'docs/',
              'title': 'T',
              'additionalInfo': 3,
            },
            'not an entry',
            <String, dynamic>{'title': 'Only a title'},
          ]),
          <Map<String, String>>[
            <String, String>{
              'baseDir': 'docs/',
              'title': 'T',
              'additionalInfo': '3',
            },
            <String, String>{
              'baseDir': '',
              'title': 'Only a title',
              'additionalInfo': '',
            },
          ],
        );
      },
    );
  });

  group('AppSettings.fromJsonFile', () {
    Map<String, dynamic> settings() => <String, dynamic>{
      'appNameDe': 'Name',
      'appNameEn': 'Name',
      'appTitleDe': 'Titel',
      'appTitleEn': 'Title',
      'disableFooter': true,
    };

    test('reads the names, the footer switch and the locales as strings', () {
      final parsed = AppSettings.fromJsonFile(<String, dynamic>{
        ...settings(),
        'supportedLocales': <dynamic>['de', 'en'],
      });
      expect(parsed.appTitleDe, 'Titel');
      expect(parsed.appTitleEn, 'Title');
      expect(parsed.disableFooter, isTrue);
      expect(parsed.supportedLocales, <String>['de', 'en']);
    });

    test('no supportedLocales is an empty list, not null', () {
      expect(AppSettings.fromJsonFile(settings()).supportedLocales, isEmpty);
    });
  });

  group('BlogPageConfig.fromJsonFile', () {
    test('reads a complete entry, the optional caption absent', () {
      final config = BlogPageConfig.fromJsonFile(_blogEntry());
      expect(config.routingName, '/aiBlog');
      expect(config.landingPageEntryImageCaptioning, isNull);
      expect(config.docsDesc, isEmpty);
    });

    test('every required field, removed in turn, is named in the error', () {
      for (final key in _blogEntry().keys) {
        final entry = _blogEntry()..remove(key);
        expect(
          () => BlogPageConfig.fromJsonFile(entry),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              contains(key),
            ),
          ),
          reason: key,
        );
      }
    });
  });
}
