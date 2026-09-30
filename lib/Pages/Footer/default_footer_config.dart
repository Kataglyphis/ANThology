import 'package:flutter/material.dart';
import 'package:anthology/Pages/Footer/footer_config.dart';
import 'package:anthology/Url/external_link_config.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// The shared footer; links are an argument so no consumer advertises somebody else's sites.
/// Requires [AnthologyLocalizations.delegate] on the enclosing [MaterialApp].
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
