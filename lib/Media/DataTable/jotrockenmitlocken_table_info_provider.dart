import 'package:jotrockenmitlockenrepo/Media/DataTable/datacell_content_strategies.dart';

mixin JotrockenmitlockenTableInfoProvider {
  List<double> getSpacing(bool isMobileDevice);
  List<DataCellContentStrategies> getDataCellContentStrategies();
}
