import 'package:flutter/material.dart';

class AdaptiveGrid extends StatefulWidget {
  final MainAxisAlignment rowAlignment;
  final int maxgridWidgetsPerRow;
  final List<Widget> gridWidgets;

  const AdaptiveGrid({
    super.key,
    required this.rowAlignment,
    required this.maxgridWidgetsPerRow,
    required this.gridWidgets,
  });

  @override
  State<StatefulWidget> createState() => AdaptiveGridState();
}

class AdaptiveGridState extends State<AdaptiveGrid> {
  @override
  Widget build(BuildContext context) {
    final int maxNumRows =
        (widget.gridWidgets.length / widget.maxgridWidgetsPerRow).ceil();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < maxNumRows; i++)
          // Align spans a bounded width and hugs an unbounded one, as the Row did; the Wrap breaks a row a phone cannot fit.
          Align(
            alignment: switch (widget.rowAlignment) {
              MainAxisAlignment.start => AlignmentDirectional.centerStart,
              MainAxisAlignment.end => AlignmentDirectional.centerEnd,
              _ => AlignmentDirectional.center,
            },
            child: Wrap(
              alignment: switch (widget.rowAlignment) {
                MainAxisAlignment.start => WrapAlignment.start,
                MainAxisAlignment.end => WrapAlignment.end,
                MainAxisAlignment.center => WrapAlignment.center,
                MainAxisAlignment.spaceBetween => WrapAlignment.spaceBetween,
                MainAxisAlignment.spaceAround => WrapAlignment.spaceAround,
                MainAxisAlignment.spaceEvenly => WrapAlignment.spaceEvenly,
              },
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (int j = 0; j < widget.maxgridWidgetsPerRow; j++)
                  if (i * widget.maxgridWidgetsPerRow + j <
                      widget.gridWidgets.length)
                    widget.gridWidgets[i * widget.maxgridWidgetsPerRow + j],
              ],
            ),
          ),
      ],
    );
  }
}
