import 'package:jotrockenmitlockenrepo/Pages/stateful_branch_info_provider.dart';

class SqliteTestPageConfig extends StatefulBranchInfoProvider {
  const SqliteTestPageConfig();

  @override
  String getRoutingName() {
    return '/sqliteTest';
  }
}
