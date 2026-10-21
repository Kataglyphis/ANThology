import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:anthology/user_settings.dart';

// const: icon tree shaking keeps only the glyphs it finds in constants, and a final map's values were dropped.
const Map<String, FaIconData> socialMediaIcons = {
  'Facebook': FontAwesomeIcons.facebook,
  'GitHub': FontAwesomeIcons.github,
  'YouTube': FontAwesomeIcons.youtube,
  'X': FontAwesomeIcons.xTwitter,
  'LinkedIn': FontAwesomeIcons.linkedin,
  'Instagram': FontAwesomeIcons.instagram,
  'PayPal': FontAwesomeIcons.paypal,
};

/// The networks [userSettings] links to without an icon here; each would render as an empty footer button.
List<String> socialNetworksWithoutIcon(UserSettings userSettings) => <String>[
  for (final String network
      in userSettings.socialMediaLinksConfig?.keys ?? const <String>[])
    if (!socialMediaIcons.containsKey(network)) network,
];
