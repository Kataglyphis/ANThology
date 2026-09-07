import 'package:flutter/material.dart';
import 'package:anthology/Layout/ResponsiveDesign/single_page.dart';
import 'package:anthology/Pages/DataPage/BlockOverviewPage/block_entry.dart';
import 'package:anthology/Pages/DataPage/BlockOverviewPage/block_entry_list.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/app_attributes.dart';
import 'package:anthology/blog_dependent_app_attributes.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// Page listing every configured blog post in one sortable table.
///
/// Requires [AnthologyLocalizations.delegate] on the enclosing [MaterialApp].
class BlockOverviewPage extends StatefulWidget {
  final AppAttributes appAttributes;
  final BlogDependentAppAttributes blogDependentAppAttributes;
  final Footer footer;
  const BlockOverviewPage({
    super.key,
    required this.appAttributes,
    required this.footer,
    required this.blogDependentAppAttributes,
  });

  @override
  State<StatefulWidget> createState() => BlockOverviewPageState();
}

class BlockOverviewPageState extends State<BlockOverviewPage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AnthologyLocalizations.of(context)!;
    List<BlockEntry> blockEntries = widget
        .blogDependentAppAttributes
        .blockSettings
        .map(
          (config) => BlockEntry(
            title: (Localizations.localeOf(context) == const Locale("de"))
                ? config.shortDescriptionDE
                : config.shortDescriptionEN,
            date: config.lastModified,
            comment: config.routingName,
          ),
        )
        .toList();
    return SinglePage(
      footer: widget.footer,
      appAttributes: widget.appAttributes,
      showMediumSizeLayout: widget.appAttributes.showMediumSizeLayout,
      showLargeSizeLayout: widget.appAttributes.showLargeSizeLayout,
      children: [
        BlockEntryList(
          entryRedirectText: localizations.entryRedirectText,
          appAttributes: widget.appAttributes,
          title: localizations.blockEntryOverview,
          description: "${localizations.blockEntryOverviewDescription}😺",
          sortColumnIndex: 2,
          dataCategories: const ["Titel", "Date", "Comment"],
          data: blockEntries,
        ),
      ],
    );
  }
}
