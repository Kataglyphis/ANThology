// import 'package:flutter/material.dart';
// import 'package:jotrockenmitlockenrepo/Decoration/Charts/pie_chart_data_entry.dart';
// import 'package:jotrockenmitlockenrepo/constants.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class PieChart extends StatefulWidget {
//   const PieChart(
//       {super.key,
//       required this.chartConfig,
//       required this.title,
//       this.animate = true});
//   final Map<String, double> chartConfig;
//   final String title;
//   final bool animate;
//   @override
//   PieChartState createState() => PieChartState();
// }

// class PieChartState extends State<PieChart> {
//   @override
//   Widget build(BuildContext context) {
//     final List<PieChartDataEntry> chartData = [];
//     widget.chartConfig.forEach((entryName, valueInPercentage) {
//       chartData.add(PieChartDataEntry(entryName, valueInPercentage));
//     });

//     final double currentWith = MediaQuery.of(context).size.width;
//     final bool enableSkillTableLegend =
//         (currentWith >= narrowScreenWidthThreshold) ? false : true;
//     // https://help.syncfusion.com/flutter/circular-charts/overview
//     return SfCircularChart(
//       title: ChartTitle(
//           text: widget.title,
//           textStyle: Theme.of(context).textTheme.headlineLarge),
//       legend: Legend(
//           width: '100%',
//           overflowMode: LegendItemOverflowMode.wrap,
//           isVisible: enableSkillTableLegend,
//           position: LegendPosition.bottom),
//       series: <CircularSeries>[
//         // Render pie chart
//         DoughnutSeries<PieChartDataEntry, String>(
//             dataSource: chartData,
//             xValueMapper: (PieChartDataEntry data, _) => data.x,
//             yValueMapper: (PieChartDataEntry data, _) => data.y,
//             dataLabelMapper: (PieChartDataEntry data, _) => data.x,
//             // Explode the segments on tap
//             animationDuration: (widget.animate) ? 1000 : 0,
//             animationDelay: 500,
//             explode: true,
//             explodeIndex: 5,
//             radius: (MediaQuery.of(context).size.width >=
//                     narrowScreenWidthThreshold)
//                 ? '80%'
//                 : '80%',
//             innerRadius: '20%',
//             dataLabelSettings: DataLabelSettings(
//               textStyle: Theme.of(context).textTheme.bodyLarge,
//               labelPosition: ChartDataLabelPosition.outside,
//               isVisible: !enableSkillTableLegend,
//               labelIntersectAction: LabelIntersectAction.shift,
//             )),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:jotrockenmitlockenrepo/Decoration/Charts/pie_chart_data_entry.dart';
import 'package:jotrockenmitlockenrepo/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  const PieChartWidget(
      {super.key,
      required this.chartConfig,
      required this.title,
      this.animate = true});
  final Map<String, double> chartConfig;
  final String title;
  final bool animate;

  @override
  PieChartWidgetState createState() => PieChartWidgetState();
}

class PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final List<PieChartDataEntry> chartData = widget.chartConfig.entries
        .map((entry) => PieChartDataEntry(entry.key, entry.value))
        .toList();

    final double currentWidth = MediaQuery.of(context).size.width;
    final bool isMobileDevice = currentWidth < narrowScreenWidthThreshold;

    List<PieChartSectionData> getSections() {
      return chartData
          .asMap()
          .map<int, PieChartSectionData>((index, data) {
            final isTouched = index == touchedIndex;
            final double fontSize = isTouched
                ? Theme.of(context).textTheme.labelLarge!.fontSize!
                : Theme.of(context).textTheme.labelLarge!.fontSize!;

            double radius = isTouched ? 220.0 : 200.0;

            if (isMobileDevice) {
              radius = isTouched ? currentWidth * 0.9 : currentWidth * 0.8;
            }

            final section = PieChartSectionData(
              color: Colors.primaries[index % Colors.primaries.length],
              value: data.y,
              title: '${data.x}\n${data.y.toStringAsFixed(1)}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
              ),
            );

            return MapEntry(index, section);
          })
          .values
          .toList();
    }

    return Column(
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: getSections(),
              centerSpaceRadius: 40,
            ),
            swapAnimationDuration: widget.animate
                ? const Duration(milliseconds: 1000)
                : Duration.zero,
            swapAnimationCurve: Curves.easeInOut,
          ),
        ),
        if (isMobileDevice)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: chartData
                .map((data) => Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          color: Colors.primaries[chartData.indexOf(data) %
                              Colors.primaries.length],
                        ),
                        const SizedBox(width: 5),
                        Text(data.x),
                      ],
                    ))
                .toList(),
          ),
      ],
    );
  }
}
