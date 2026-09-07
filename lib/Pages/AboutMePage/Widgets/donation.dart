import 'package:flutter/material.dart';
import 'package:anthology/Decoration/row_divider.dart';
import 'package:anthology/Media/Image/openable_image.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// Donation call-to-action: the PayPal and coffee images plus their caption.
///
/// Requires [AnthologyLocalizations.delegate] to be registered on the enclosing
/// [MaterialApp]; without it the caption lookup is null and this throws.
class Donation extends StatefulWidget {
  const Donation({super.key});

  @override
  State<Donation> createState() => _DonationState();
}

class _DonationState extends State<Donation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: OpenableImage(
                displayedImage:
                    "packages/anthology/assets/images/Pages/AboutMe/paypal.jpg",
                disableOpen: true,
              ),
            ),
            Flexible(
              child: OpenableImage(
                displayedImage:
                    "packages/anthology/assets/images/Pages/AboutMe/Coffee-removebg.png",
                disableOpen: false,
              ),
            ),
          ],
        ),
        rowDivider,
        Text(
          "${AnthologyLocalizations.of(context)!.spendCoffe}☕",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }
}
