import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:anthology/Decoration/centered_box_decoration.dart';
import 'package:anthology/Decoration/row_divider.dart';
import 'package:anthology/Media/DataTable/datacell_content_strategies.dart';
import 'package:anthology/Media/DataTable/table_data.dart';
import 'package:anthology/constants.dart';

class _MyDataTableSource extends DataTableSource {
  List<DataRow> dataRows;
  _MyDataTableSource(this.dataRows);

  @override
  DataRow? getRow(int index) {
    return dataRows[index];
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dataRows.length;

  @override
  int get selectedRowCount => 0;
}

class AnthologyTable<T extends TableData> extends StatefulWidget {
  const AnthologyTable({
    super.key,
    required this.dataCategories,
    required this.title,
    required this.description,
    required this.data,
    required this.spacing,
    required this.dataCellContentStrategies,
    required this.entryRedirectText,
    this.sortColumnIndex = 0,
    this.sortOnLoaded = false,
    this.isAscending = false,
  });
  final String title;
  final String entryRedirectText;
  final List<double> spacing;
  final List<String> dataCategories;
  final List<DataCellContentStrategies> dataCellContentStrategies;
  final List<T> data;
  final String description;
  final bool sortOnLoaded;
  final int sortColumnIndex;
  final bool isAscending;
  @override
  AnthologyTableState<T> createState() => AnthologyTableState<T>();
}

class AnthologyTableState<T extends TableData>
    extends State<AnthologyTable<T>> {
  late int sortColumnIndex = widget.sortColumnIndex;
  late bool isAscending = widget.isAscending;

  /// Rows keep the order they came in until sorted on load or by a header tap.
  late bool _sorted = widget.sortOnLoaded;

  /// The rows in the order shown; the caller's list is never reordered.
  List<T> sortedRows() {
    final rows = List<T>.from(widget.data);
    if (_sorted) {
      rows.sort((data1, data2) {
        final order = data1.getCells()[sortColumnIndex].compareTo(
          data2.getCells()[sortColumnIndex],
        );
        return isAscending ? order : -order;
      });
    }
    return rows;
  }

  List<DataRow> getDataRows(List<T> csvData, double maxWidth) {
    return csvData.map((T data) {
      return DataRow(
        cells: data.getCells().indexed.map((cell) {
          final (entryIndex, entry) = cell;
          DataCellContentStrategies currentStrat =
              widget.dataCellContentStrategies[entryIndex];
          bool returnText =
              currentStrat == DataCellContentStrategies.text ||
              (currentStrat == DataCellContentStrategies.textButton &&
                  entry == "");
          return DataCell(
            SizedBox(
              width: (maxWidth) * widget.spacing[entryIndex],
              child: returnText
                  ? Text(entry, overflow: TextOverflow.visible, softWrap: true)
                  : TextButton(
                      onPressed: () {
                        context.go(entry);
                      },
                      child: Text(
                        textAlign: TextAlign.center,
                        widget.entryRedirectText,
                      ),
                    ),
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double dataTableWidth = responsiveWidth(
      MediaQuery.of(context).size.width,
      large: 0.8,
    );

    final DataTableSource dataTableSource = _MyDataTableSource(
      getDataRows(sortedRows(), dataTableWidth),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        rowDivider,
        Text(
          widget.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        rowDivider,
        SizedBox(
          width: dataTableWidth,
          child: CenteredBoxDecoration(
            borderRadius: 8,
            borderWidth: 6,
            color: Theme.of(context).colorScheme.primary,
            child: PaginatedDataTable(
              dataRowMaxHeight: double.infinity,
              sortColumnIndex: sortColumnIndex,
              sortAscending: isAscending,
              columns: widget.dataCategories
                  .map(
                    (String column) => DataColumn(
                      label: Text(column),
                      onSort: (int columnIndex, bool ascending) {
                        setState(() {
                          sortColumnIndex = columnIndex;
                          isAscending = ascending;
                          _sorted = true;
                        });
                      },
                    ),
                  )
                  .toList(),
              source: dataTableSource,
            ),
          ),
        ),
      ],
    );
  }
}
