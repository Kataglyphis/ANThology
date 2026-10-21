import 'package:anthology/Pages/Footer/footer_page_config.dart';
import 'package:anthology/Pages/Footer/generic_footer_page_config.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// The route the footer's licence entry takes; the router builds [OpenSourceLicensesPage] for it, not a Markdown page.
const String openSourceLicensesRoute = '/openSourceLicenses';

const String _footerDocs = 'packages/anthology/assets/documents/footer';

/// The footer pages both apps show: the legal texts this package ships, and the licence list.
List<FooterPageConfig> defaultFooterPageConfigs() {
  return <FooterPageConfig>[
    GenericFooterPageConfig(
      routingName: '/imprint',
      headingBuilder: (context) => AnthologyLocalizations.of(context)!.imprint,
      filePathDe: '$_footerDocs/imprintDe.md',
      filePathEn: '$_footerDocs/imprintEn.md',
    ),
    GenericFooterPageConfig(
      routingName: '/contact',
      headingBuilder: (context) => AnthologyLocalizations.of(context)!.contact,
      filePathDe: '$_footerDocs/contactDe.md',
      filePathEn: '$_footerDocs/contactEn.md',
    ),
    GenericFooterPageConfig(
      routingName: '/privacyPolicy',
      headingBuilder: (context) =>
          AnthologyLocalizations.of(context)!.privacyPolicy,
      filePathDe: '$_footerDocs/privacyPolicyDe.md',
      filePathEn: '$_footerDocs/privacyPolicyEn.md',
    ),
    GenericFooterPageConfig(
      routingName: '/cookieDeclaration',
      headingBuilder: (context) =>
          AnthologyLocalizations.of(context)!.cookieStatement,
      filePathDe: '$_footerDocs/cookieDeclarationDe.md',
      filePathEn: '$_footerDocs/cookieDeclarationEn.md',
    ),
    GenericFooterPageConfig(
      routingName: '/declarationOnAccessibility',
      headingBuilder: (context) =>
          AnthologyLocalizations.of(context)!.declarationOnAccessibility,
      filePathDe: '$_footerDocs/declarationOnAccessibilityDe.md',
      filePathEn: '$_footerDocs/declarationOnAccessibilityEn.md',
    ),
    GenericFooterPageConfig(
      routingName: '/copyright',
      headingBuilder: (context) =>
          AnthologyLocalizations.of(context)!.copyrightFooterTitle,
      filePathDe: '$_footerDocs/copyRightDe.md',
      filePathEn: '$_footerDocs/copyRightEn.md',
    ),
    GenericFooterPageConfig(
      routingName: openSourceLicensesRoute,
      headingBuilder: (context) =>
          AnthologyLocalizations.of(context)!.openSourceLicenses,
      filePathDe: '',
      filePathEn: '',
    ),
  ];
}
