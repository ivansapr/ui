import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthSpendingChart extends StatefulWidget {
  const MonthSpendingChart({super.key});

  @override
  State<MonthSpendingChart> createState() => _MonthSpendingChartState();
}

class _MonthSpendingChartState extends State<MonthSpendingChart> {
  final transactions = <int, double>{};

  @override
  void initState() {
    super.initState();
    final random = Random();

    const startAmount = 1000.0;

    final a = List.generate(30, (index) => random.nextInt(200).toDouble() - 100);

    transactions[1] = startAmount;

    for (var day = 2; day < 31; day++) {
      transactions[day] = transactions[day - 1]! + a[day - 1];
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Colors.cyan,
      Colors.blue,
    ];
    final bars = LineChartBarData(
      spots:
          transactions.keys.map((e) => FlSpot(e.toDouble(), transactions[e]!.toDouble())).toList(),
      isCurved: true,
      gradient: LinearGradient(
        colors: gradientColors,
      ),
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
      // belowBarData: BarAreaData(
      //   show: true,
      //   gradient: LinearGradient(
      //     colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
      //   ),
      // ),
    );

    var max = transactions.values.fold(0.0, (p, e) => e > p ? e : p).toDouble();
    final min = transactions.values.fold(max, (p, e) => e < p ? e : p).toDouble();
    final avg = max + min / 2;

    final data = LineChartData(
      rangeAnnotations: RangeAnnotations(
        horizontalRangeAnnotations: [
          HorizontalRangeAnnotation(
            y1: 10,
            y2: 20,
            color: Colors.red,
          ),
        ],
      ),
      lineBarsData: [bars],
      minY: ((min * 0.9) / 100).ceilToDouble() * 100,
      maxY: max * 1.1,
      baselineY: 100,
      titlesData: const FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          axisNameSize: 10,
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50,
          ),
        ),
      ),

      borderData: FlBorderData(show: false),
      // extraLinesData: ExtraLinesData(
      //   horizontalLines: [
      //     HorizontalLine(
      //       y: 0,
      //       color: Colors.red,
      //       strokeWidth: 3,
      //       dashArray: [5, 5],
      //     ),
      //   ],
      // ),
      gridData: FlGridData(
        horizontalInterval: max / 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => const FlLine(
          color: Colors.black12,
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => const FlLine(
          color: Colors.black12,
          strokeWidth: 1,
        ),
      ),
    );
    return LineChart(data);
  }
}
