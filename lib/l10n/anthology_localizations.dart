import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'anthology_localizations_de.dart';
import 'anthology_localizations_en.dart';
import 'anthology_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AnthologyLocalizations
/// returned by `AnthologyLocalizations.of(context)`.
///
/// Applications need to include `AnthologyLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/anthology_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AnthologyLocalizations.localizationsDelegates,
///   supportedLocales: AnthologyLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AnthologyLocalizations.supportedLocales
/// property.
abstract class AnthologyLocalizations {
  AnthologyLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AnthologyLocalizations? of(BuildContext context) {
    return Localizations.of<AnthologyLocalizations>(
      context,
      AnthologyLocalizations,
    );
  }

  static const LocalizationsDelegate<AnthologyLocalizations> delegate =
      _AnthologyLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
  ];

  /// Label for the light/dark mode affordance.
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get brightness;

  /// Tooltip on the button that flips between light and dark mode. Spelling of the key is kept from the apps' original catalogues so the hoist is a pure move.
  ///
  /// In en, this message translates to:
  /// **'Toggle brightness'**
  String get toogleBrightness;

  /// Label of the locale picker. Deliberately neutral: a hard-coded 'Switch (DE/EN)' is wrong for any app shipping a third locale.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get switchLang;

  /// Tooltip on the locale picker.
  ///
  /// In en, this message translates to:
  /// **'Toggle language'**
  String get toogleLanguage;

  /// Label of the Material 3 seed-colour picker.
  ///
  /// In en, this message translates to:
  /// **'Select a seed color'**
  String get selectSeedColor;

  /// Footer page title for the legal imprint.
  ///
  /// In en, this message translates to:
  /// **'Imprint'**
  String get imprint;

  /// Footer page title for the contact details.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Footer page title for the privacy policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacyPolicy;

  /// Footer page title for the cookie declaration.
  ///
  /// In en, this message translates to:
  /// **'Cookie statement'**
  String get cookieStatement;

  /// Footer page title for the accessibility declaration.
  ///
  /// In en, this message translates to:
  /// **'Declaration on accessibility'**
  String get declarationOnAccessibility;

  /// Footer page title for the copyright notice. The notice text itself names a specific rights holder and therefore stays in the consuming app.
  ///
  /// In en, this message translates to:
  /// **'Copyright'**
  String get copyrightFooterTitle;

  /// Heading above the footer's outbound link list.
  ///
  /// In en, this message translates to:
  /// **'External links'**
  String get externalLinks;

  /// Prefix in front of a document's last-modification date.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get lastModified;

  /// Title of OpenSourceLicensesPage.
  ///
  /// In en, this message translates to:
  /// **'Open source licenses'**
  String get openSourceLicenses;

  /// Intro paragraph rendered by OpenSourceLicensesPage.
  ///
  /// In en, this message translates to:
  /// **'This page lists third-party packages and their license texts used in this app.'**
  String get openSourceLicensesDescription;

  /// Shown by OpenSourceLicensesPage when LicenseRegistry fails.
  ///
  /// In en, this message translates to:
  /// **'The open source licenses could not be loaded.'**
  String get openSourceLicensesError;

  /// Shown by OpenSourceLicensesPage when LicenseRegistry yields nothing.
  ///
  /// In en, this message translates to:
  /// **'No open source licenses are currently available.'**
  String get openSourceLicensesEmpty;

  /// Label of CopyButton, which copies a code block or quote to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyLabel;

  /// Label of OpenButton, which opens the attached document.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openLabel;

  /// Headline of SqliteTestPage.
  ///
  /// In en, this message translates to:
  /// **'SQLite self test'**
  String get sqliteSelfTestTitle;

  /// Sub-headline of SqliteTestPage.
  ///
  /// In en, this message translates to:
  /// **'Runs a minimal query and shows the result.'**
  String get sqliteSelfTestDescription;

  /// Label of the SqliteTestPage button while idle.
  ///
  /// In en, this message translates to:
  /// **'Run test'**
  String get sqliteSelfTestRunLabel;

  /// Label of the SqliteTestPage button while the self test is in flight.
  ///
  /// In en, this message translates to:
  /// **'Running…'**
  String get sqliteSelfTestRunningLabel;

  /// Prefix in front of a thrown SQLite self-test error. Trailing space is intentional.
  ///
  /// In en, this message translates to:
  /// **'ERROR: '**
  String get sqliteSelfTestErrorPrefix;

  /// Title of the pie chart breaking a day down into activities.
  ///
  /// In en, this message translates to:
  /// **'My perfect Day'**
  String get myPerfectDay;

  /// Perfect-day chart slice.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get sleep;

  /// Perfect-day chart slice.
  ///
  /// In en, this message translates to:
  /// **'Studying'**
  String get studying;

  /// Perfect-day chart slice.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// Perfect-day chart slice.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get meditation;

  /// Perfect-day chart slice.
  ///
  /// In en, this message translates to:
  /// **'Guitar'**
  String get guitar;

  /// Perfect-day chart slice.
  ///
  /// In en, this message translates to:
  /// **'Family and friends'**
  String get familyFriends;

  /// One-line bio under the portrait on the about-me table.
  ///
  /// In en, this message translates to:
  /// **'Interested in many things. I love breathing life into artificial neurons.'**
  String get shortDescriptionTextMyPersona;

  /// Label of the mailto button on the about-me table.
  ///
  /// In en, this message translates to:
  /// **'Mail Me'**
  String get mailMe;

  /// Caption under the donation images. Key spelling kept from the apps' original catalogues so the hoist is a pure move.
  ///
  /// In en, this message translates to:
  /// **'You can get me some coffee'**
  String get spendCoffe;

  /// Title of the blog-post overview table.
  ///
  /// In en, this message translates to:
  /// **'Overview of all my blog posts'**
  String get blockEntryOverview;

  /// Subtitle of the blog-post overview table.
  ///
  /// In en, this message translates to:
  /// **'Does not include reviews of books/movies/games'**
  String get blockEntryOverviewDescription;

  /// Text of the cell button that opens a blog post.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get entryRedirectText;

  /// Landing-page link to the blog-post overview. Replaces a hard-coded de/en ternary that silently served English to a third locale.
  ///
  /// In en, this message translates to:
  /// **'Go to the overview of all blog entries'**
  String get blogEntriesOverviewLink;

  /// Headline of a landing-page entry.
  ///
  /// In en, this message translates to:
  /// **'Visit blog entry'**
  String get visitBlogEntry;

  /// Description under a landing-page entry's source-repository link.
  ///
  /// In en, this message translates to:
  /// **'Visit my code repo'**
  String get playgroundDescription;

  /// Copyright line rendered in the footer liability block.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2024 Jonas Heinle. \nAll rights reserved.'**
  String get copyright;

  /// External-link liability disclaimer rendered in the footer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer: I accept no liability for the content of external links.'**
  String get disclaimer;
}

class _AnthologyLocalizationsDelegate
    extends LocalizationsDelegate<AnthologyLocalizations> {
  const _AnthologyLocalizationsDelegate();

  @override
  Future<AnthologyLocalizations> load(Locale locale) {
    return SynchronousFuture<AnthologyLocalizations>(
      lookupAnthologyLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AnthologyLocalizationsDelegate old) => false;
}

AnthologyLocalizations lookupAnthologyLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AnthologyLocalizationsDe();
    case 'en':
      return AnthologyLocalizationsEn();
    case 'fr':
      return AnthologyLocalizationsFr();
  }

  throw FlutterError(
    'AnthologyLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
