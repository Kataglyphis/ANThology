import 'package:flutter/material.dart';

import 'package:jotrockenmitlockenrepo/Media/DataTable/jotrockenmitlocken_table.dart';
import 'package:jotrockenmitlockenrepo/Media/DataTable/jotrockenmitlocken_table_info_provider.dart';
import 'package:jotrockenmitlockenrepo/Media/DataTable/table_data.dart';

import 'package:jotrockenmitlockenrepo/constants.dart';

abstract class DataList<T extends TableData> extends StatefulWidget {
  const DataList(
      {super.key,
      required this.title,
      required this.description,
      required this.data,
      required this.dataCategories,
      required this.entryRedirectText,
      this.sortColumnIndex = 0,
      this.sortOnLoaded = false,
      this.isAscending = false});
  final List<T> data;
  final List<String> dataCategories;
  final String title;
  final String description;
  final String entryRedirectText;
  final bool sortOnLoaded;
  final int sortColumnIndex;
  final bool isAscending;
}

abstract class DataListState<T extends TableData, U extends DataList>
    extends State<U> with JotrockenmitlockenTableInfoProvider {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    bool isMobileDevice = currentWidth <= narrowScreenWidthThreshold;
    return JotrockenmitlockenTable(
      dataCategories: widget.dataCategories,
      data: widget.data,
      title: widget.title,
      entryRedirectText: widget.entryRedirectText,
      description: widget.description,
      sortColumnIndex: widget.sortColumnIndex,
      isAscending: widget.isAscending,
      sortOnLoaded: widget.sortOnLoaded,
      spacing: getSpacing(isMobileDevice),
      dataCellContentStrategies: getDataCellContentStrategies(),
    );
  }
}
