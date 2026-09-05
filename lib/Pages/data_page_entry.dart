import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:anthology/Decoration/component_group_decoration.dart';
import 'package:anthology/Decoration/row_divider.dart';
import 'package:anthology/Media/Image/openable_image.dart';

class DataPageEntry extends StatelessWidget {
  const DataPageEntry({
    super.key,
    required this.label,
    required this.routerPath,
    required this.imagePath,
    required this.description,
    required this.lastModified,
    required this.followLabel,
    this.imageCaptioning,
  });

  final String label;
  final String routerPath;
  final String imagePath;
  final String description;
  final String? imageCaptioning;
  final String lastModified;
  final String followLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ComponentGroupDecoration(
            label: label,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              rowDivider,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      context.go(routerPath);
                    },
                    child: Text(
                      followLabel,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              rowDivider,
              OpenableImage(
                displayedImage: imagePath,
                disableOpen: true,
                imageCaptioning: imageCaptioning,
              ),
              rowDivider,
              Padding(
                padding: const EdgeInsets.only(right: 34.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      lastModified,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
