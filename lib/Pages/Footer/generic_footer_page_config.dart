import 'package:flutter/material.dart';
import 'package:anthology/Pages/Footer/footer_page_config.dart';

class GenericFooterPageConfig extends FooterPageConfig {
  final String Function(BuildContext) headingBuilder;
  final String routingName;
  final String filePathDe;
  final String filePathEn;

  GenericFooterPageConfig({
    required this.headingBuilder,
    required this.routingName,
    required this.filePathDe,
    required this.filePathEn,
  });

  @override
  String getHeading(BuildContext context) {
    return headingBuilder(context);
  }

  @override
  String getRoutingName() {
    return routingName;
  }

  @override
  String getFilePathDe() {
    return filePathDe;
  }

  @override
  String getFilePathEn() {
    return filePathEn;
  }
}
