import 'package:material_ui/material_ui.dart';
import 'package:anthology/Url/external_link_config.dart';

abstract class FooterConfig {
  String getLiabilityText(BuildContext context);
  String getExternalLinksTitle(BuildContext context);
  List<ExternalLinkConfig> getExternalLinks(BuildContext context);
}
