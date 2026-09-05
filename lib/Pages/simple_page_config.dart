import 'package:anthology/Pages/stateful_branch_info_provider.dart';

class SimplePageConfig extends StatefulBranchInfoProvider {
  final String _route;
  const SimplePageConfig(this._route);
  @override
  String getRoutingName() => _route;
}
