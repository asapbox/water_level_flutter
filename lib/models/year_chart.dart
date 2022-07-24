import 'package:json_annotation/json_annotation.dart';
import 'package:level_river/models/gauge.dart';

part 'year_chart.g.dart';

@JsonSerializable()
class YearChart {
  YearChart({required this.year, required this.gauges});

  final String year;
  final List<Gauge?> gauges;

  factory YearChart.fromJson(Map<String, dynamic> json) => _$YearChartFromJson(json);

  Map<String, dynamic> toJson() => _$YearChartToJson(this);
}
