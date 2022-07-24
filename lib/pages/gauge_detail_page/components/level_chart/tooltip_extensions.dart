part of 'level_chart.dart';

extension toolTipExtension on _LevelChartState {
  _getLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.grey.shade900,
        showOnTopOfTheChartBoxArea: true,
        tooltipMargin: 0,
        getTooltipItems: _getTooltipItems,
        fitInsideHorizontally: true,
        // fitInsideVertically: true,
      ),
      touchCallback: _touchCallback,
      handleBuiltInTouches: true,
      getTouchLineEnd: (LineChartBarData barData, int spotIndex) => double.infinity,
      getTouchedSpotIndicator: _handlerGetTouchedSpotIndicator,
    );
  }

  List<TouchedSpotIndicatorData> _handlerGetTouchedSpotIndicator(
      LineChartBarData barData, List<int> spotIndexes) {
    return spotIndexes.map((index) {
      return TouchedSpotIndicatorData(
        FlLine(
          color: Colors.grey.shade600,
          strokeWidth: 1.0,
        ),
        FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
            radius: 8,
            color: barData.color,
            strokeWidth: 1.5,
            strokeColor: Theme.of(context).colorScheme.background,
          ),
        ),
      );
    }).toList();
  }

  List<LineTooltipItem> _getTooltipItems(List<LineBarSpot> lineBarsSpot) {
    final List<LineTooltipItem> items = [];

    for (var i = 0; i < lineBarsSpot.length; i++) {
      final lineBarSpot = lineBarsSpot[i];
      final text = '${lineBarSpot.y.round()} ${S.of(context).centimeterShort}';
      final color = colors[lineBarSpot.barIndex];
      final item = LineTooltipItem(
        text,
        TextStyle(color: color, fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      );
      items.add(item);
    }
    // items.add(LineTooltipItem(
    //   "text",
    //   TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
    //   textAlign: TextAlign.right,
    // ));

    return items;
  }
}
