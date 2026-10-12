import 'package:flutter/material.dart';
import 'package:anthology/Decoration/col_divider.dart';
import 'package:anthology/Decoration/row_divider.dart';
import 'package:anthology/Pages/Footer/footer_config.dart';
import 'package:anthology/Pages/Footer/Sections/footer_external_links.dart';
import 'package:anthology/Pages/Footer/Sections/footer_pages_text_buttons.dart';
import 'package:anthology/Pages/Footer/Sections/footer_social_icons_and_liability.dart';
import 'package:anthology/Pages/Footer/footer_page_config.dart';
import 'package:anthology/constants.dart';
import 'package:anthology/user_settings.dart';

class Footer extends StatefulWidget {
  const Footer({
    super.key,
    required this.footerPagesConfigs,
    required this.userSettings,
    required this.footerConfig,
  });

  final List<FooterPageConfig> footerPagesConfigs;
  final FooterConfig footerConfig;
  final UserSettings userSettings;

  @override
  State<StatefulWidget> createState() => FooterState();
}

class FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    var currentWidth = MediaQuery.of(context).size.width;
    if (currentWidth < mediumWidthBreakpoint) {
      return Column(
        children: [
          rowDivider,
          FooterPagesTextButtons(footerPagesConfig: widget.footerPagesConfigs),
          rowDivider,
          FooterSocialIconsAndLiability(
            footerConfig: widget.footerConfig,
            userSettings: widget.userSettings,
          ),
          rowDivider,
          FooterExternalLinks(
            footerConfig: widget.footerConfig,
            userSettings: widget.userSettings,
          ),
          rowDivider,
        ],
      );
    } else {
      // Its content's height, not a fixed 150 px, which cut off the fourth row of page links; it is the Scaffold's bottom bar here.
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          rowDivider,
          // Scales the row down when a large text size makes it wider than the window; stacked, as on a phone, the pinned footer would fill it.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                colDivider,
                FooterPagesTextButtons(
                  footerPagesConfig: widget.footerPagesConfigs,
                ),
                colDivider,
                FooterSocialIconsAndLiability(
                  footerConfig: widget.footerConfig,
                  userSettings: widget.userSettings,
                ),
                colDivider,
                FooterExternalLinks(
                  footerConfig: widget.footerConfig,
                  userSettings: widget.userSettings,
                ),
              ],
            ),
          ),
          rowDivider,
        ],
      );
    }
  }
}
