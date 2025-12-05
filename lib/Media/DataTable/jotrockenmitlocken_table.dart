import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jotrockenmitlockenrepo/Decoration/centered_box_decoration.dart';
import 'package:jotrockenmitlockenrepo/Decoration/row_divider.dart';
import 'package:jotrockenmitlockenrepo/Media/DataTable/datacell_content_strategies.dart';
import 'package:jotrockenmitlockenrepo/Media/DataTable/table_data.dart';
import 'package:jotrockenmitlockenrepo/constants.dart';

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

class JotrockenmitlockenTable<T extends TableData> extends StatefulWidget {
  const JotrockenmitlockenTable({
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
  JotrockenmitlockenTableState<T> createState() =>
      JotrockenmitlockenTableState<T>();
}

class JotrockenmitlockenTableState<T extends TableData>
    extends State<JotrockenmitlockenTable<T>> {
  late int sortColumnIndex;
  late bool isAscending;

  @override
  void initState() {
    super.initState();
    sortColumnIndex = widget.sortColumnIndex;
    isAscending = widget.isAscending;

    if (widget.sortOnLoaded) {
      widget.data.sort(
        (data1, data2) => _compareString(
          isAscending,
          data1.getCells()[sortColumnIndex],
          data2.getCells()[sortColumnIndex],
        ),
      );
    }
  }

  int _compareString(bool ascending, String value1, String value2) {
    return ascending ? value1.compareTo(value2) : value2.compareTo(value1);
  }

  List<DataRow> getDataRows(List<T> csvData, double maxWidth) {
    return csvData.map((T data) {
      return DataRow(
        cells: data.getCells().map((entry) {
          int entryIndex = data.getCells().indexOf(entry);
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
    double currentWidth = MediaQuery.of(context).size.width;
    double dataTableWidth = (currentWidth >= largeWidthBreakpoint)
        ? currentWidth * 0.8
        : currentWidth * 0.9;

    if (widget.sortOnLoaded) {
      widget.data.sort(
        (data1, data2) => _compareString(
          isAscending,
          data1.getCells()[widget.sortColumnIndex],
          data2.getCells()[widget.sortColumnIndex],
        ),
      );
    }
    final DataTableSource dataTableSource = _MyDataTableSource(
      getDataRows(widget.data, dataTableWidth),
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
                          widget.data.sort(
                            (data1, data2) => _compareString(
                              isAscending,
                              data1.getCells()[columnIndex],
                              data2.getCells()[columnIndex],
                            ),
                          );

                          sortColumnIndex = columnIndex;
                          isAscending = ascending;
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
