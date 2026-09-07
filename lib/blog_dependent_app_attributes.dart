import 'package:anthology/Pages/blog_dependent_screen_configurations.dart';
import 'package:anthology/blog_page_config.dart';
import 'package:anthology/my_two_cents_config.dart';

/// Everything parsed out of an app's blog settings, handed to the shared pages.
///
/// An app carrying extra blog-adjacent state subclasses this rather than
/// widening it: the shared widgets only ever read the three fields declared
/// here, so a subclass field stays invisible to them and to the other app.
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
