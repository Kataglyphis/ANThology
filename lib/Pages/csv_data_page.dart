import 'package:flutter/material.dart';
import 'package:jotrockenmitlockenrepo/Pages/Footer/footer.dart';
import 'package:jotrockenmitlockenrepo/app_attributes.dart';
import 'package:jotrockenmitlockenrepo/Layout/ResponsiveDesign/single_page.dart';

class CsvDataPage extends StatefulWidget {
  final AppAttributes appAttributes;
  final Footer footer;
  final Widget child;

  const CsvDataPage({
    super.key,
    required this.appAttributes,
    required this.footer,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => CsvDataPageState();
}

class CsvDataPageState extends State<CsvDataPage> {
  @override
  Widget build(BuildContext context) {
    return SinglePage(
      footer: widget.footer,
      appAttributes: widget.appAttributes,
      showMediumSizeLayout: widget.appAttributes.showMediumSizeLayout,
      showLargeSizeLayout: widget.appAttributes.showLargeSizeLayout,
      children: [widget.child],
    );
  }
}
