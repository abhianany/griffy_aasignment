// line_chart_widget.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:griffy_assignment/parts/chart_state.dart';

/// A widget that displays a line chart based on the given ChartState.
class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key, required this.chartState});

  /// The current state of the chart.
  final ChartState chartState;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Line chart price vs time",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 400,
          child: LineChart(
            LineChartData(
              minX: chartState.minX,
              maxX: chartState.maxX,
              minY: 500,
              maxY: 1000,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: calculateInterval(chartState.minX, chartState.maxX),
                    getTitlesWidget: (value, meta) {
                      int minutes = (value / 60).floor();
                      int seconds = (value % 60).toInt();
                      return Text(
                        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
              ),
              gridData: const FlGridData(
                drawHorizontalLine: true,
                horizontalInterval: 50,
              ),
              clipData: const FlClipData.all(),
              lineBarsData: [
                LineChartBarData(
                  isCurved: true,
                  barWidth: 1,
                  dotData: const FlDotData(
                    show: false,
                  ),
                  spots: chartState.spots,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  double calculateInterval(double minX, double maxX) {
    // Calculate the range of visible x-axis values
    double range = maxX - minX;

    // Choose an interval based on the range
    if (range <= 60) {
      return 10; // Display every 10 seconds
    } else if (range <= 300) {
      return 30; // Display every 30 seconds
    } else {
      return 60; // Display every minute
    }
  }
}
