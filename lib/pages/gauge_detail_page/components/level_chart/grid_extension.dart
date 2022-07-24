part of 'level_chart.dart';

extension buildGridExtension on _LevelChartState {
  getGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      drawHorizontalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: theme.colorScheme.chartGridColor,
          strokeWidth: 0.1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: theme.colorScheme.chartGridColor,
          strokeWidth: 0.1,
        );
      },
      // verticalInterval: 1,
      horizontalInterval: 100,
      checkToShowVerticalLine: _checkShowTitle,
      checkToShowHorizontalLine: _checkShowTitle,
    );
  }

  double getGridVerticalInterval() {
    switch (_selectedDateRange) {
      case ChartDateRange.month:
        return 7.0;
      case ChartDateRange.year:
        return 30.0;
      default:
        return 0.0;
    }
  }
}
