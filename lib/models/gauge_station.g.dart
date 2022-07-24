// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gauge_station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GaugeStation _$GaugeStationFromJson(Map<String, dynamic> json) => GaugeStation(
      gauges: (json['gauges'] as List<dynamic>?)
              ?.map((e) => Gauge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      slug: json['slug'] as String,
      location: json['location'] as String,
      water: Water.fromJson(json['water'] as Map<String, dynamic>),
      minGauge: json['minGauge'] == null
          ? null
          : Gauge.fromJson(json['minGauge'] as Map<String, dynamic>),
      maxGauge: json['maxGauge'] == null
          ? null
          : Gauge.fromJson(json['maxGauge'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GaugeStationToJson(GaugeStation instance) =>
    <String, dynamic>{
      'slug': instance.slug,
      'location': instance.location,
      'water': instance.water,
      'minGauge': instance.minGauge,
      'maxGauge': instance.maxGauge,
      'gauges': instance.gauges,
    };
