// chart_notifier.dart

import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:griffy_assignment/parts/chart_state.dart';

/// A state notifier for managing and updating the ChartState.
class ChartNotifier extends StateNotifier<ChartState> {
  int nextX = 0;
  Timer? timer;

  /// Initializes the ChartNotifier with initial data and starts the timer.
  ChartNotifier(List<double> initialData)
      : super(ChartState(
      spots: List.generate(initialData.length,
              (index) => FlSpot(index.toDouble(), initialData[index])),
      minX: 0,
      maxX: 100)) {
    nextX = initialData.length;
    startTimer();
  }

  bool _isPinching = false;
  double _initialMinX = 0.0;
  double _initialMaxX = 100.0;
  double _pinchCenterX = 0.0;

  void startPinch(double centerX) {
    _isPinching = true;
    _initialMinX = state.minX;
    _initialMaxX = state.maxX;
    _pinchCenterX = centerX;
  }

  void pinchUpdate(double scale) {
    if (_isPinching) {
      double currentWidth = _initialMaxX - _initialMinX;
      double newWidth = currentWidth / scale;
      double newMinX = _pinchCenterX - (_pinchCenterX - _initialMinX) / scale;
      double newMaxX = newMinX + newWidth;

      newMinX = newMinX.clamp(0.0, nextX.toDouble() - 1.0);
      newMaxX = newMaxX.clamp(newMinX + 1.0, nextX.toDouble());

      state = state.copyWith(minX: newMinX, maxX: newMaxX);
    }
  }

  void endPinch() {
    _isPinching = false;
  }

  /// Starts a timer to add a new data point every 3 seconds.
  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      addDataPoint(550 + Random().nextDouble() * (990 - 550));
    });
  }


  /// Adds a new data point to the chart.
  void addDataPoint(double value) {
    final newSpots = List<FlSpot>.from(state.spots)
      ..add(FlSpot(nextX.toDouble(), value));
    nextX++;
    double newMinX = state.minX;
    double newMaxX = state.maxX;
    if (nextX > newMaxX) {
      newMinX++;
      newMaxX++;
    }
    state = state.copyWith(spots: newSpots, minX: newMinX, maxX: newMaxX);
  }

  /// Zooms in the chart view.
  void zoomIn() {
    double newMinX =
    (state.minX + (state.maxX - state.minX) * 0.05).clamp(0, nextX.toDouble() - 1);
    double newMaxX =
    (state.maxX - (state.maxX - state.minX) * 0.05).clamp(newMinX + 1, nextX.toDouble());
    state = state.copyWith(minX: newMinX, maxX: newMaxX);
  }

  /// Zooms out the chart view.
  void zoomOut() {
    double newMinX =
    (state.minX - (state.maxX - state.minX) * 0.05).clamp(0, nextX.toDouble() - 1);
    double newMaxX =
    (state.maxX + (state.maxX - state.minX) * 0.05).clamp(newMinX + 1, nextX.toDouble());
    state = state.copyWith(minX: newMinX, maxX: newMaxX);
  }

  /// Pans the chart view.
  void pan(double delta) {
    double panFactor = 0.005 * (state.maxX - state.minX);
    double newMinX = state.minX;
    double newMaxX = state.maxX;
    if (delta < 0) {
      newMinX =
          (state.minX + panFactor).clamp(0, nextX.toDouble() - (state.maxX - state.minX));
      newMaxX =
          (state.maxX + panFactor).clamp(newMinX + 1, nextX.toDouble());
    } else {
      newMinX =
          (state.minX - panFactor).clamp(0, nextX.toDouble() - (state.maxX - state.minX));
      newMaxX =
          (state.maxX - panFactor).clamp(newMinX + 1, nextX.toDouble());
    }
    state = state.copyWith(minX: newMinX, maxX: newMaxX);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}