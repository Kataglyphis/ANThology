import 'package:flutter/material.dart';
import 'package:anthology/Layout/adaptive_grid.dart';
import 'package:anthology/SocialMedia/Settings/social_media_settings.dart';
import 'package:anthology/Url/browser_helper.dart';
import 'package:anthology/Url/external_link_config.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:anthology/constants.dart';

class SocialMediaWidgets extends StatelessWidget {
  const SocialMediaWidgets({super.key, required this.socialMediaLinksConfig});

  final Map<String, ExternalLinkConfig> socialMediaLinksConfig;

  List<Widget> buildSocialMediaChildren() {
    List<Widget> socialMediaIconsWithSpacing = [];
    socialMediaLinksConfig.forEach(
      (key, socialMediaLinkConfig) => (socialMediaIconsWithSpacing.addAll([
        Padding(
          padding: const EdgeInsets.all(2.5),
          child: IconButton(
            icon: FaIcon(socialMediaIcons[key]),
            onPressed: () {
              BrowserHelper.launchInBrowser(socialMediaLinkConfig);
            },
          ),
        ),
      ])),
    );
    return socialMediaIconsWithSpacing;
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    int maxGridWidgetsPerRow = 7;
    if (currentWidth < narrowScreenWidthThreshold) {
      maxGridWidgetsPerRow = 4;
    }
    return AdaptiveGrid(
      rowAlignment: MainAxisAlignment.center,
      gridWidgets: buildSocialMediaChildren(),
      maxgridWidgetsPerRow: maxGridWidgetsPerRow,
    );
  }
}
