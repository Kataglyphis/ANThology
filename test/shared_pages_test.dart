import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:anthology/Pages/AboutMePage/Widgets/perfect_day_chart.dart';
import 'package:anthology/Pages/DataPage/BlockOverviewPage/block_entry.dart';
import 'package:anthology/Pages/ErrorPage/error_page_stateful_branch_info_provider.dart';
import 'package:anthology/Pages/ErrorPage/error_page_widget.dart';
import 'package:anthology/Pages/Footer/default_footer_config.dart';
import 'package:anthology/Pages/Home/default_home_config.dart';
import 'package:anthology/Url/external_link_config.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/json_helpers.dart';
import 'package:anthology/l10n/anthology_localizations.dart';
import 'package:anthology/my_two_cents_config.dart';

/// A complete blog settings map; individual tests strip one field from a copy.
Map<String, dynamic> _blogJson() => <String, dynamic>{
  'routingName': '/myBlog',
  'shortDescriptionEN': 'A short description',
  'shortDescriptionDE': 'Eine kurze Beschreibung',
  'filePath': 'assets/documents/blog/myBlog.md',
  'imageDir': 'assets/images/myBlog',
  'githubRepo': '/myRepo',
  'landingPageAlignment': 'left',
  'landingPageEntryImagePath': 'assets/images/myBlog/entry.jpg',
  'lastModified': '01.01.2024',
  'fileTitle': 'MyBlog.pdf',
  'fileAdditionalInfo': 'PDF version',
  'fileBaseDir': 'assets/documents/blog/',
};

Map<String, dynamic> _twoCentsJson() => <String, dynamic>{
  'routingName': '/aBook',
  'filePath': 'assets/documents/books/aBook.md',
  'imageDir': 'assets/images/books',
  'mediaTitle': 'A Book',
  'fileBaseDir': 'assets/documents/books/',
};

/// Pumps [read] inside a real Localizations scope for [locale].
Future<T> _pumpAndRead<T>(
  WidgetTester tester,
  Locale locale,
  T Function(BuildContext context) read,
) async {
  late T seen;
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AnthologyLocalizations.localizationsDelegates,
      supportedLocales: AnthologyLocalizations.supportedLocales,
      home: Builder(
        builder: (BuildContext context) {
          seen = read(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return seen;
}

void main() {
  group('json_helpers', () {
    test('requireStringField returns the value when present', () {
      expect(requireStringField(<String, dynamic>{'a': 'b'}, 'a'), 'b');
    });

    test('requireStringField throws on an absent key', () {
      expect(
        () => requireStringField(<String, dynamic>{}, 'a'),
        throwsA(isA<FormatException>()),
      );
    });

    test('requireStringField throws on a non-string value', () {
      expect(
        () => requireStringField(<String, dynamic>{'a': 7}, 'a'),
        throwsA(isA<FormatException>()),
      );
    });

    test('parseDocsDesc treats an absent array as no appendices', () {
      expect(parseDocsDesc(null), isEmpty);
    });

    test('parseDocsDesc throws when the value is present but not a list', () {
      expect(() => parseDocsDesc('nope'), throwsA(isA<FormatException>()));
    });

    test('parseDocsDesc fills every field, defaulting a missing one', () {
      final List<Map<String, String>> parsed = parseDocsDesc(<dynamic>[
        <String, dynamic>{'baseDir': 'a/', 'title': 'T', 'additionalInfo': 'I'},
        <String, dynamic>{'baseDir': 'b/'},
      ]);

      expect(parsed, hasLength(2));
      expect(parsed[0], <String, String>{
        'baseDir': 'a/',
        'title': 'T',
        'additionalInfo': 'I',
      });
      expect(parsed[1]['title'], '');
      expect(parsed[1]['additionalInfo'], '');
    });
  });

  group('BlogPageConfig', () {
    test('parses a complete settings entry', () {
      final BlogPageConfig config = BlogPageConfig.fromJsonFile(_blogJson());

      expect(config.getRoutingName(), '/myBlog');
      expect(config.filePath, 'assets/documents/blog/myBlog.md');
      expect(config.docsDesc, isEmpty);
    });

    test('an absent image caption is null rather than a crash', () {
      // jotrockenmitlocken read this with `as String`, so a settings entry
      // without a caption threw a TypeError while loading the whole app.
      final BlogPageConfig config = BlogPageConfig.fromJsonFile(_blogJson());

      expect(config.landingPageEntryImageCaptioning, isNull);
    });

    test('a missing required field is reported, not silently defaulted', () {
      final Map<String, dynamic> json = _blogJson()..remove('filePath');

      expect(
        () => BlogPageConfig.fromJsonFile(json),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('MyTwoCentsConfig', () {
    test('parses a complete settings entry', () {
      final MyTwoCentsConfig config = MyTwoCentsConfig.fromJsonFile(
        _twoCentsJson(),
      );

      expect(config.getRoutingName(), '/aBook');
      expect(config.mediaTitle, 'A Book');
      expect(config.docsDesc, isEmpty);
    });

    test('a missing required field is reported, not silently defaulted', () {
      final Map<String, dynamic> json = _twoCentsJson()..remove('mediaTitle');

      expect(
        () => MyTwoCentsConfig.fromJsonFile(json),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('BlockEntry', () {
    test('renders its cells in table order', () {
      final BlockEntry entry = BlockEntry(title: 'T', date: 'D', comment: 'C');

      expect(entry.getCells(), <String>['T', 'D', 'C']);
    });
  });

  group('ErrorPage routing', () {
    test('the branch provider names the error route', () {
      expect(
        ErrorPageStatefulBranchInfoProvider().getRoutingName(),
        '/errorPage',
      );
    });

    test('the error widget is stateless', () {
      // jotrockenmitlocken carried a StatefulWidget whose State held nothing.
      // Pinning this stops that variant from creeping back in.
      expect(const ErrorPageWidget(), isA<StatelessWidget>());
    });
  });

  group('PerfectDayState.getDayHourPercentage', () {
    test('converts hours to a rounded share of the day', () {
      expect(PerfectDayState.getDayHourPercentage(8), 33.33);
      expect(PerfectDayState.getDayHourPercentage(24), 100.0);
      expect(PerfectDayState.getDayHourPercentage(12), 50.0);
      expect(PerfectDayState.getDayHourPercentage(0), 0.0);
      expect(PerfectDayState.getDayHourPercentage(1), 4.17);
    });
  });

  group('DefaultHomeConfig', () {
    testWidgets('labels the chrome buttons from the shared catalogue', (
      WidgetTester tester,
    ) async {
      final DefaultHomeConfig config = DefaultHomeConfig();

      final List<String?> de = await _pumpAndRead(tester, const Locale('de'), (
        BuildContext context,
      ) {
        final names = config.getButtonNames(context);
        return <String?>[names.brightness, names.language];
      });
      final List<String?> fr = await _pumpAndRead(tester, const Locale('fr'), (
        BuildContext context,
      ) {
        final names = config.getButtonNames(context);
        return <String?>[names.brightness, names.language];
      });

      expect(de[0], 'Wechsel Helligkeit');
      expect(de[1], 'Sprache');
      expect(fr[1], 'Langue');
      expect(fr[0], isNot(equals(de[0])));
    });
  });

  group('DefaultFooterConfig', () {
    testWidgets('builds the liability text out of the shared catalogue', (
      WidgetTester tester,
    ) async {
      final DefaultFooterConfig config = DefaultFooterConfig();

      final String fr = await _pumpAndRead(
        tester,
        const Locale('fr'),
        (BuildContext context) => config.getLiabilityText(context),
      );
      final String en = await _pumpAndRead(
        tester,
        const Locale('en'),
        (BuildContext context) => config.getLiabilityText(context),
      );

      expect(fr, contains('Avertissement'));
      expect(fr, contains('Jonas Heinle'));
      expect(en, isNot(equals(fr)));
      expect(fr.split('\n'), hasLength(greaterThan(1)));
    });

    testWidgets('external links default, but a consumer can replace them', (
      WidgetTester tester,
    ) async {
      final List<ExternalLinkConfig> mine = <ExternalLinkConfig>[
        ExternalLinkConfig(host: 'example.org', path: '/x'),
      ];

      final List<String> defaults = await _pumpAndRead(
        tester,
        const Locale('en'),
        (BuildContext context) => DefaultFooterConfig()
            .getExternalLinks(context)
            .map((ExternalLinkConfig l) => l.host)
            .toList(),
      );
      final List<String> overridden = await _pumpAndRead(
        tester,
        const Locale('en'),
        (BuildContext context) => DefaultFooterConfig(externalLinks: mine)
            .getExternalLinks(context)
            .map((ExternalLinkConfig l) => l.host)
            .toList(),
      );

      expect(defaults, hasLength(2));
      expect(overridden, <String>['example.org']);
    });
  });
}
