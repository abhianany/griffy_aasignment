import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:griffy_assignment/line_chart_widget.dart'; // Assuming LineChartWidget is imported correctly
import 'package:griffy_assignment/parts/chart_notifier.dart';
import 'package:griffy_assignment/parts/chart_state.dart';

/// Provider for the ChartNotifier.
final chartNotifierProvider = StateNotifierProvider<ChartNotifier, ChartState>(
    (ref) => ChartNotifier(generateRandomPrices(100)));

/// A widget that manages the line plot interactions and displays the LineChartWidget.
class LinePlot extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartState = ref.watch(chartNotifierProvider);
    final chartNotifier = ref.read(chartNotifierProvider.notifier);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 500,
              child: Listener(
                onPointerSignal: (signal) {
                  if (signal is PointerScrollEvent) {
                    if (signal.scrollDelta.dy.isNegative) {
                      chartNotifier.zoomIn();
                    } else {
                      chartNotifier.zoomOut();
                    }
                  }
                },
                child: GestureDetector(
                  onDoubleTap: () {
                    chartNotifier.state = chartNotifier.state.copyWith(
                      minX: 0,
                      maxX: chartNotifier.state.spots.length.toDouble(),
                    );
                  },
                  onHorizontalDragUpdate: (dragDetails) {
                    double primaryDelta = dragDetails.primaryDelta ?? 0.0;
                    if (primaryDelta != 0) {
                      chartNotifier.pan(primaryDelta);
                    }
                  },
                  // Implementing pinch zoom focusing on a point
                  onScaleStart: (details) {
                    chartNotifier.startPinch(details.focalPoint.dx);
                  },
                  onScaleUpdate: (details) {
                    chartNotifier.pinchUpdate(details.scale);
                  },
                  onScaleEnd: (details) {
                    chartNotifier.endPinch();
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: LineChartWidget(
                          chartState: chartState,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'X-Axis (In Seconds)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Generates a list of random prices within the specified range.
List<double> generateRandomPrices(int count) {
  final random = Random();
  return List.generate(
      count, (index) => 550 + random.nextDouble() * (990 - 550));
}
