import 'package:flutter/material.dart';
import 'package:anthology/Decoration/centered_box_decoration.dart';
import 'package:anthology/Decoration/component_group_decoration.dart';

/// A 404 error page with an animated picture.
class ErrorPageWidget extends StatelessWidget {
  const ErrorPageWidget({super.key});

  /// The animation, an 800x600 WebP of 100 frames.
  static const String imageAsset =
      'packages/anthology/assets/images/Pages/Error/error404.webp';

  @override
  Widget build(BuildContext context) {
    const colDivider = SizedBox(height: 10);
    return ComponentGroupDecoration(
      label: 'Error 404',
      children: <Widget>[
        colDivider,
        CenteredBoxDecoration(
          borderRadius: 0,
          borderWidth: 5,
          color: Theme.of(context).colorScheme.primary,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image.asset(imageAsset),
          ),
        ),
        colDivider,
      ],
    );
  }
}
