import 'package:material_ui/material_ui.dart';
import 'package:anthology/Pages/stateful_branch_info_provider.dart';

abstract class NavBarPageConfig extends StatefulBranchInfoProvider {
  NavigationDestination getNavigationDestination(BuildContext context);
}
