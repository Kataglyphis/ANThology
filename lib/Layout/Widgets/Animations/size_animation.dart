import 'package:material_ui/material_ui.dart';

class SizeAnimation extends CurvedAnimation {
  SizeAnimation(Animation<double> parent)
    : super(
        parent: parent,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOutCubicEmphasized),
        reverseCurve: Interval(
          0,
          0.2,
          curve: Curves.easeInOutCubicEmphasized.flipped,
        ),
      );
}
