import 'package:anthology/Pages/stateful_branch_info_provider.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/my_two_cents_config.dart';

/// The blog-derived page lists an app must supply to the shared routing.
mixin BlogDependentScreenConfigurations {
  List<StatefulBranchInfoProvider> getDataPagesConfig();
  List<BlogPageConfig> getBlogPagesConfig();
  List<MyTwoCentsConfig> getMediaCriticsPagesConfig();
}
