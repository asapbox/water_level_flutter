import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:level_river/models/gauge.dart';
import 'package:level_river/models/gauge_station.dart';

import '../../../themes.dart';

class GaugeCard extends StatelessWidget {
  final GaugeStation gaugeStation;
  final Function(GaugeStation) onTap;
  final bool showChart;

  const GaugeCard({
    Key? key,
    required this.gaugeStation,
    required this.onTap,
    this.showChart = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onTap(gaugeStation),
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      gaugeStation.water.name.trim(),
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      // overflow: TextOverflow.clip,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      maxLines: 2,
                    ),
                    Container(height: 10.0),
                    Text(
                      gaugeStation.location.trim(),
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              // Spacer(),
              Container(width: 10.0),
              Container(
                margin: const EdgeInsets.all(10.0),
                width: showChart ? 100 : 0,
                height: 70,
                child: showChart ? buildChartData(context) : Container(),
              ),
              Container(width: 10),
              SizedBox(
                width: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      gaugeStation.lastLevel?.toString() ?? '',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      gaugeStation.diffLevelLastGaugeText ?? '-',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildChartData(context) {
    ThemeData theme = Theme.of(context);
    final List<Gauge> gauges = List.from(gaugeStation.gauges)
      ..sort((a, b) => a.date.compareTo(b.date));
    final graphColor = theme.colorScheme.chartBarColor;
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            curveSmoothness: 0.5,
            spots: buildChartSpots(gauges.map((g) => g.level).toList()),
            isCurved: false,
            barWidth: 1,
            color: theme.colorScheme.chartBarColor,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  graphColor.withOpacity(0.5),
                  graphColor.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(handleBuiltInTouches: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }

  List<FlSpot> buildChartSpots(List<int?> values) {
    List<FlSpot> spots = [];
    for (var i = 0; i < values.length; i++) {
      final value = values[i];
      if (value != null) spots.add(FlSpot(i.toDouble(), value.toDouble()));
    }
    if (spots.isEmpty) spots.add(FlSpot(0.0, 0.0));
    return spots;
  }
}
