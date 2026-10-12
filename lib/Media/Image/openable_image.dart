import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:anthology/Decoration/centered_box_decoration.dart';
import 'package:anthology/Decoration/row_divider.dart';
import 'package:anthology/Media/Open/open_button.dart';

/// A 1x1 transparent PNG, the fade-in's start when no placeholder is given.
final Uint8List _transparentPixel = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNgYGBgAAAABQABeqhXUAAAAABJRU5ErkJggg==',
);

class OpenableImage extends StatefulWidget {
  OpenableImage({
    super.key,
    required this.displayedImage,
    this.placeholderImage,
    this.imageCaptioning,
    this.captioningStyle,
    this.disableOpen = false,
  }) {
    final String? placeholder = placeholderImage;
    ourMainImage = FadeInImage(
      placeholder: placeholder == null
          ? MemoryImage(_transparentPixel)
          : AssetImage(placeholder),
      image: AssetImage(displayedImage),
    );
  }

  /// Shown while [displayedImage] loads; none by default, as a 766 kB cat photo was, on every page with an image.
  final String? placeholderImage;
  final String displayedImage;
  final String? imageCaptioning;
  final TextStyle? captioningStyle;
  final bool disableOpen;
  late final FadeInImage ourMainImage;

  @override
  State<StatefulWidget> createState() => _OpenableImageState();
}

class _OpenableImageState extends State<OpenableImage> {
  double imageWidth = 0;
  double imageHeight = 0;
  bool initializedImage = false;

  double getImageWidth(double imageWidth) {
    var currentPageWidth = MediaQuery.of(context).size.width;
    if (imageWidth < currentPageWidth) {
      return imageWidth;
    } else {
      return currentPageWidth;
    }
  }

  late ImageStreamListener imageListener;

  @override
  Widget build(BuildContext context) {
    if (!initializedImage) {
      initializedImage = true;
      imageListener = ImageStreamListener((ImageInfo info, bool _) {
        if (mounted) {
          setState(() {
            imageHeight = info.image.height.toDouble();
            double retrievedImageWidth = info.image.width.toDouble();
            imageWidth = getImageWidth(retrievedImageWidth).toDouble();
          });
        }
      });
      widget.ourMainImage.image
          .resolve(const ImageConfiguration())
          .addListener(imageListener);
    } else {
      widget.ourMainImage.image
          .resolve(const ImageConfiguration())
          .removeListener(imageListener);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: imageWidth),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: CenteredBoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: widget.ourMainImage,
                  ),
                ),
              ),
              if (!widget.disableOpen)
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: OpenButton(assetFullPath: widget.displayedImage),
                  ),
                ),
            ],
          ),
        ),
        if (widget.imageCaptioning != null) ...[
          rowDivider,
          Text(
            widget.imageCaptioning!,
            textAlign: TextAlign.center,
            style: widget.captioningStyle,
          ),
        ],
      ],
    );
  }
}
