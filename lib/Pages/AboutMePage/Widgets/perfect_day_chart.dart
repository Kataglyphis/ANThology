import 'package:flutter/material.dart';
import 'package:anthology/Decoration/Charts/pie_chart.dart';
import 'package:anthology/Decoration/Charts/pie_chart_data_entry.dart';
import 'package:anthology/constants.dart';
import 'package:anthology/l10n/anthology_localizations.dart';

/// Pie chart breaking a 24 hour day down into activities.
/// Requires [AnthologyLocalizations.delegate] on the enclosing [MaterialApp].
class PerfectDay extends StatefulWidget {
  const PerfectDay({super.key});

  @override
  PerfectDayState createState() => PerfectDayState();
}

class PerfectDayState extends State<PerfectDay> {
  /// The percentage of a day that [hoursPerDay] represents, rounded to 2 decimals.
  static double getDayHourPercentage(double hoursPerDay) {
    final percentage = (hoursPerDay / 24) * 100;
    return double.parse(percentage.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AnthologyLocalizations.of(context)!;
    final Map<String, double> chartConfig = {
      localizations.sleep: getDayHourPercentage(8),
      localizations.studying: getDayHourPercentage(8),
      localizations.sports: getDayHourPercentage(2),
      localizations.meditation: getDayHourPercentage(1),
      localizations.guitar: getDayHourPercentage(1),
      localizations.familyFriends: getDayHourPercentage(4),
    };

    final List<PieChartDataEntry> chartData = [];
    chartConfig.forEach((entryName, valueInPercentage) {
      chartData.add(PieChartDataEntry(entryName, valueInPercentage));
    });
    double currentWidth = MediaQuery.of(context).size.width;
    // IntrinsicHeight: in an unbounded scroll column the pie would get no height at all.
    return IntrinsicHeight(
      child: PieChartWidget(
        chartConfig: chartConfig,
        title: localizations.myPerfectDay,
        animate: currentWidth > narrowScreenWidthThreshold,
      ),
    );
  }
}
