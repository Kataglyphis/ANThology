import 'package:anthology/Pages/blog_dependent_screen_configurations.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/my_two_cents_config.dart';

/// Everything parsed out of an app's blog settings, handed to the shared pages.
/// Subclass it for app-only state: the shared widgets read only these three fields.
class BlogDependentAppAttributes {
  List<MyTwoCentsConfig> twoCentsConfigs;
  List<BlogPageConfig> blockSettings;

  BlogDependentScreenConfigurations blogDependentScreenConfigurations;

  BlogDependentAppAttributes({
    required this.blogDependentScreenConfigurations,
    required this.twoCentsConfigs,
    required this.blockSettings,
  });
}
