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
    final years = copyrightYears(DateTime.now());
    return "${localizations.disclaimer}\n${localizations.copyright(years)}";
  }
}

/// `2024` in 2024, `2024–2026` later: the site first went up in 2024, and a fixed year goes stale.
String copyrightYears(DateTime now) =>
    now.year > 2024 ? '2024–${now.year}' : '2024';
