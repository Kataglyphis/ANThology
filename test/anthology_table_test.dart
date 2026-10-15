import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:anthology/Media/DataTable/anthology_table.dart';
import 'package:anthology/Media/DataTable/csv_data_list.dart';
import 'package:anthology/Media/DataTable/datacell_content_strategies.dart';
import 'package:anthology/Media/DataTable/table_data.dart';

class _Row extends TableData {
  _Row(this.cells);
  final List<String> cells;

  @override
  List<String> getCells() => cells;
}

const _text = DataCellContentStrategies.text;
const _link = DataCellContentStrategies.textButton;

AnthologyTable<_Row> _table(
  List<_Row> data, {
  List<DataCellContentStrategies> kinds = const [_text, _text],
  List<double> spacing = const [0.4, 0.4],
  int sortColumnIndex = 0,
  bool sortOnLoaded = false,
  bool isAscending = false,
}) => AnthologyTable<_Row>(
  dataCategories: [for (var i = 0; i < kinds.length; i++) 'Column $i'],
  title: 'Books',
  description: 'Worth reading',
  data: data,
  spacing: spacing,
  dataCellContentStrategies: kinds,
  entryRedirectText: 'Open',
  sortColumnIndex: sortColumnIndex,
  sortOnLoaded: sortOnLoaded,
  isAscending: isAscending,
);

/// Hosts [child] on a desktop-sized page under a router, so a link cell can navigate.
Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: SingleChildScrollView(child: child)),
      ),
      GoRoute(path: '/review', builder: (_, _) => const Text('the review')),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();
}

DataTable _shownTable(WidgetTester tester) =>
    tester.widget<DataTable>(find.byType(DataTable));

/// The data rows shown, without the blank ones that fill a page.
List<DataRow> _rows(WidgetTester tester) => [
  for (final row in _shownTable(tester).rows)
    if ((row.cells.first.child as SizedBox).child != null) row,
];

/// What the first cell of each row shows, top to bottom.
List<String> _firstColumn(WidgetTester tester) => [
  for (final row in _rows(tester))
    ((row.cells.first.child as SizedBox).child! as Text).data!,
];

List<_Row> _books() => [
  _Row(['Dune', '1965']),
  _Row(['Anathem', '2008']),
  _Row(['Hyperion', '1989']),
];

void main() {
  testWidgets('rows keep the order they came in until sorted', (tester) async {
    await _pump(tester, _table(_books()));
    expect(_firstColumn(tester), ['Dune', 'Anathem', 'Hyperion']);
  });

  testWidgets('sorted on load by its column, descending unless asked', (
    tester,
  ) async {
    await _pump(
      tester,
      _table(_books(), sortColumnIndex: 1, sortOnLoaded: true),
    );
    expect(_firstColumn(tester), ['Anathem', 'Hyperion', 'Dune']);
    await _pump(
      tester,
      _table(
        _books(),
        sortColumnIndex: 1,
        sortOnLoaded: true,
        isAscending: true,
      ),
    );
    expect(_firstColumn(tester), ['Dune', 'Hyperion', 'Anathem']);
  });

  testWidgets('a header tap sorts the way its arrow points', (tester) async {
    await _pump(tester, _table(_books()));
    await tester.tap(find.text('Column 0'));
    await tester.pumpAndSettle();
    expect(_shownTable(tester).sortAscending, isTrue);
    expect(_firstColumn(tester), ['Anathem', 'Dune', 'Hyperion']);
    await tester.tap(find.text('Column 0'));
    await tester.pumpAndSettle();
    expect(_shownTable(tester).sortAscending, isFalse);
    expect(_firstColumn(tester), ['Hyperion', 'Dune', 'Anathem']);
  });

  testWidgets('a table sorted on load sorts by the column tapped next', (
    tester,
  ) async {
    final books = _books();
    await _pump(tester, _table(books, sortColumnIndex: 1, sortOnLoaded: true));
    await tester.tap(find.text('Column 0'));
    await tester.pumpAndSettle();
    expect(_shownTable(tester).sortColumnIndex, 0);
    expect(_firstColumn(tester), ['Anathem', 'Dune', 'Hyperion']);
    // The caller's list is shown sorted, never reordered.
    expect(books.map((b) => b.cells.first), ['Dune', 'Anathem', 'Hyperion']);
  });

  testWidgets(
    'each cell takes its own column, also when two cells hold the same text',
    (tester) async {
      await _pump(
        tester,
        _table(
          [
            _Row(['', '', '/review']),
          ],
          kinds: const [_text, _link, _link],
          spacing: const [0.1, 0.2, 0.3],
        ),
      );
      final cells = _rows(tester).single.cells;
      final widths = [for (final c in cells) (c.child as SizedBox).width!];
      expect(widths[1] / widths[0], closeTo(2, 1e-9));
      expect(widths[2] / widths[0], closeTo(3, 1e-9));
      // An empty link cell shows nothing to press; a filled one opens its route.
      expect((cells[1].child as SizedBox).child, isA<Text>());
      await tester.tap(find.widgetWithText(TextButton, 'Open'));
      await tester.pumpAndSettle();
      expect(find.text('the review'), findsOneWidget);
    },
  );

  group('CsvDataList', () {
    testWidgets(
      'shows the file\'s header row as columns and the rest as rows',
      (tester) async {
        await _pump(
          tester,
          _CsvBooks(
            _Bundle({'books.csv': 'Title,Year\nDune,1965\nAnathem,2008\n'}),
          ),
        );
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Year'), findsOneWidget);
        expect(_firstColumn(tester), ['Dune', 'Anathem']);
      },
    );

    testWidgets('a file that does not load shows the error, not a spinner', (
      tester,
    ) async {
      await _pump(tester, _CsvBooks(_Bundle({})));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.textContaining('books.csv'), findsOneWidget);
    });
  });
}

/// An asset bundle that holds [files] as text and nothing else.
class _Bundle extends CachingAssetBundle {
  _Bundle(this.files);
  final Map<String, String> files;

  @override
  Future<ByteData> load(String key) async {
    final text = files[key];
    if (text == null) throw FlutterError('no asset $key');
    return ByteData.sublistView(utf8.encode(text));
  }
}

class _CsvBooks extends CsvDataList {
  const _CsvBooks(AssetBundle bundle)
    : super(
        dataFilePath: 'books.csv',
        title: 'Books',
        description: 'Worth reading',
        entryRedirectText: 'Open',
        assetBundle: bundle,
      );

  @override
  State<_CsvBooks> createState() => _CsvBooksState();
}

class _CsvBooksState extends CsvDataListState<_Row, _CsvBooks> {
  @override
  Future<(List<_Row>, List<String>)> convertRawCSVDataToFinalLayout(
    List<List<dynamic>> csvListData,
  ) async => (
    [
      for (final line in csvListData.skip(1))
        _Row([for (final v in line) '$v']),
    ],
    [for (final v in csvListData.first) '$v'],
  );

  @override
  List<double> getSpacing(bool isMobileDevice) => const [0.4, 0.4];

  @override
  List<DataCellContentStrategies> getDataCellContentStrategies() => const [
    _text,
    _text,
  ];
}
