import 'package:flutter/material.dart';
import 'package:anthology/Pages/Footer/footer_config.dart';
import 'package:anthology/Url/external_link_config.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// The footer configuration both apps were carrying a private copy of.
///
/// The liability block and the external-links title come from
/// [AnthologyLocalizations], so its delegate must be registered on the
/// enclosing [MaterialApp]. The link list is a constructor argument rather
/// than a hard-coded constant so a consumer is not forced to advertise
/// somebody else's sites.
class DefaultFooterConfig extends FooterConfig {
  DefaultFooterConfig({List<ExternalLinkConfig>? externalLinks})
    : _externalLinks =
          externalLinks ??
          [
            ExternalLinkConfig(host: 'johannes-heinle.de', path: ''),
            ExternalLinkConfig(host: 'dom-wuest.de', path: ''),
          ];

  final List<ExternalLinkConfig> _externalLinks;

  @override
  List<ExternalLinkConfig> getExternalLinks(BuildContext context) {
    return _externalLinks;
  }

  @override
  String getExternalLinksTitle(BuildContext context) {
    return AnthologyLocalizations.of(context)!.externalLinks;
  }

  @override
  String getLiabilityText(BuildContext context) {
    final localizations = AnthologyLocalizations.of(context)!;
    return "${localizations.disclaimer}\n${localizations.copyright}";
  }
}
