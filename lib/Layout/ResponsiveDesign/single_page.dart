import 'package:flutter/material.dart';
import 'package:anthology/Decoration/col_divider.dart';
import 'package:anthology/Layout/Widgets/Scrolling/first_component_list.dart';
import 'package:anthology/Pages/Footer/footer.dart';
import 'package:anthology/app_attributes.dart';

class SinglePage extends StatefulWidget {
  final List<Widget> children;
  final Footer footer;
  final bool showMediumSizeLayout;
  final bool showLargeSizeLayout;
  final AppAttributes appAttributes;

  const SinglePage({
    super.key,
    required this.children,
    required this.footer,
    required this.appAttributes,
    required this.showMediumSizeLayout,
    required this.showLargeSizeLayout,
  });
  @override
  State<StatefulWidget> createState() => SinglePageState();
}

class SinglePageState extends State<SinglePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: FirstComponentList(
            showSecondList: false,
            childWidgetsLeftPage:
                [...widget.children] +
                [
                  colDivider,
                  if (!widget.showMediumSizeLayout &&
                      !widget.showLargeSizeLayout &&
                      !widget.appAttributes.appSettings.disableFooter) ...[
                    widget.footer,
                  ],
                ],
            childWidgetsRightPage: const [],
          ),
        ),
      ],
    );
  }
}
