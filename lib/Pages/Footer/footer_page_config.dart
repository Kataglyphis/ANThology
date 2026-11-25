import 'package:material_ui/material_ui.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';

abstract class FooterPageConfig extends StatefulBranchInfoProvider {
  String getHeading(BuildContext context);
  String getFilePathEn();
  String getFilePathDe();
}
