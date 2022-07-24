part of 'level_chart.dart';

extension BuildBordersExtension on _LevelChartState {
  _buildBorderData() {
    final borderColor = theme.colorScheme.chartGridColor;
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: borderColor, width: 0.1),
        left: BorderSide(color: borderColor, width: 0.1),
        top: BorderSide(color: borderColor, width: 0.1),
      ),
    );
  }
}
