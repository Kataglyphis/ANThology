import 'package:anthology/Media/DataTable/datacell_content_strategies.dart';

mixin AnthologyTableInfoProvider {
  List<double> getSpacing(bool isMobileDevice);
  List<DataCellContentStrategies> getDataCellContentStrategies();
}
