import 'package:fl_chart/fl_chart.dart';

/// Represents the state of the chart.
class ChartState {
  /// List of data points to be displayed on the chart.
  final List<FlSpot> spots;

  /// Minimum x-axis value visible on the chart.
  final double minX;

  /// Maximum x-axis value visible on the chart.
  final double maxX;

  /// Creates a new ChartState.
  ChartState({required this.spots, required this.minX, required this.maxX});

  /// Creates a copy of the current ChartState with optional new values.
  ChartState copyWith({List<FlSpot>? spots, double? minX, double? maxX}) {
    return ChartState(
      spots: spots ?? this.spots,
      minX: minX ?? this.minX,
      maxX: maxX ?? this.maxX,
    );
  }
}