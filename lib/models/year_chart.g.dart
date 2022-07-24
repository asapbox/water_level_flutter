// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_chart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YearChart _$YearChartFromJson(Map<String, dynamic> json) => YearChart(
      year: json['year'] as String,
      gauges: (json['gauges'] as List<dynamic>)
          .map((e) =>
              e == null ? null : Gauge.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YearChartToJson(YearChart instance) => <String, dynamic>{
      'year': instance.year,
      'gauges': instance.gauges,
    };
