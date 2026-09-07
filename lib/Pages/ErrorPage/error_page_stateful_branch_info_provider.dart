import 'package:anthology/Pages/stateful_branch_info_provider.dart';

/// Routing branch descriptor for [ErrorPage].
class ErrorPageStatefulBranchInfoProvider extends StatefulBranchInfoProvider {
  @override
  String getRoutingName() {
    return '/errorPage';
  }
}
