import 'package:anthology/Pages/stateful_branch_info_provider.dart';
import 'package:anthology/Routing/screen_configurations.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/my_two_cents_config.dart';

/// The blog-derived page lists an app must supply to the shared routing.
mixin BlogDependentScreenConfigurations on ScreenConfigurations {
  List<StatefulBranchInfoProvider> getDataPagesConfig();
  List<BlogPageConfig> getBlogPagesConfig();
  List<MyTwoCentsConfig> getMediaCriticsPagesConfig();

  /// Every page config: navigation, footer, blog posts, media reviews, error and data pages.
  @override
  List<StatefulBranchInfoProvider> getAllPagesConfigs() {
    return <StatefulBranchInfoProvider>[
      ...getNavRailPagesConfig(),
      ...getFooterPagesConfig(),
      ...getBlogPagesConfig(),
      ...getMediaCriticsPagesConfig(),
      ...getErrorPagesConfig(),
      ...getDataPagesConfig(),
    ];
  }
}
