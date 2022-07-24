part of 'level_chart.dart';

extension BuildSpotsExtension on _LevelChartState {
  List<FlSpot> _buildYearSpots(YearChart year) {
    final now = DateTime.now();

    var toDayOfYear = 365;
    if (_selectedDateRange == ChartDateRange.month)
      toDayOfYear = now.difference(new DateTime(now.year, 1, 1, 0, 0)).inDays + 7;

    fromDayOfYear = 0;
    if (_selectedDateRange == ChartDateRange.month && toDayOfYear > 31) {
      fromDayOfYear = toDayOfYear - 30;
    }

    final List<FlSpot> spots = [];
    for (var i = fromDayOfYear; i < toDayOfYear; i++) {
      final gauge = year.gauges[i];
      if (gauge != null && gauge.level != null) {
        spots.add(FlSpot(i.toDouble(), gauge.level!.toDouble()));
      } else {
        spots.add(FlSpot.nullSpot);
      }
    }
    return spots;
  }
}
