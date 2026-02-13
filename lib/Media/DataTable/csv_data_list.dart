import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

import 'package:jotrockenmitlockenrepo/Media/DataTable/jotrockenmitlocken_table.dart';
import 'package:jotrockenmitlockenrepo/Media/DataTable/jotrockenmitlocken_table_info_provider.dart';
import 'package:jotrockenmitlockenrepo/Media/DataTable/table_data.dart';
import 'package:flutter/services.dart';

import 'package:jotrockenmitlockenrepo/constants.dart';

abstract class CsvDataList extends StatefulWidget {
  const CsvDataList({
    super.key,
    required this.dataFilePath,
    required this.title,
    required this.description,
    required this.entryRedirectText,
    this.sortColumnIndex = 0,
    this.sortOnLoaded = false,
    this.isAscending = false,
  });
  final String title;
  final String entryRedirectText;
  final String dataFilePath;
  final String description;
  final bool sortOnLoaded;
  final int sortColumnIndex;
  final bool isAscending;
}

abstract class CsvDataListState<T extends TableData, U extends CsvDataList>
    extends State<U>
    with JotrockenmitlockenTableInfoProvider {
  late Future<(List<T>, List<String>)> _rawCsvData;

  Future<(List<T>, List<String>)> convertRawCSVDataToFinalLayout(
    List<List<dynamic>> csvListData,
  );

  @override
  void initState() {
    super.initState();
    _rawCsvData = _loadDataFromCSV();
  }

  Future<(List<T>, List<String>)> _loadDataFromCSV() async {
    final rawData = await rootBundle.loadString(widget.dataFilePath);
    // csv ^7 uses CsvDecoder/CsvCodec; delimiter auto-detection is built in.
    final List<List<dynamic>> csvListData = const CsvDecoder().convert(rawData);
    Future<(List<T>, List<String>)> finalData = convertRawCSVDataToFinalLayout(
      csvListData,
    );
    return finalData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _rawCsvData,
      builder: (context, data) {
        if (data.hasData) {
          List<T> csvData = data.requireData.$1;
          List<String> dataCategories = data.requireData.$2;
          //maybe now
          double currentWidth = MediaQuery.of(context).size.width;
          bool isMobileDevice = currentWidth <= narrowScreenWidthThreshold;
          return JotrockenmitlockenTable(
            dataCategories: dataCategories,
            data: csvData,
            title: widget.title,
            entryRedirectText: widget.entryRedirectText,
            description: widget.description,
            sortColumnIndex: widget.sortColumnIndex,
            isAscending: widget.isAscending,
            sortOnLoaded: widget.sortOnLoaded,
            spacing: getSpacing(isMobileDevice),
            dataCellContentStrategies: getDataCellContentStrategies(),
          );
        } else if (data.hasError) {
          return Center(child: Text("${data.error}"));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
