// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gauge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Gauge _$GaugeFromJson(Map<String, dynamic> json) => Gauge(
      date: DateTime.parse(json['date'] as String),
      level: json['level'] as int?,
    );

Map<String, dynamic> _$GaugeToJson(Gauge instance) => <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'level': instance.level,
    };
