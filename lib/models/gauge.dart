import 'package:json_annotation/json_annotation.dart';

part 'gauge.g.dart';

@JsonSerializable()
class Gauge {
  Gauge({required this.date, required this.level});

  final DateTime date;
  final int? level;

  factory Gauge.fromJson(Map<String, dynamic> json) => _$GaugeFromJson(json);

  Map<String, dynamic> toJson() => _$GaugeToJson(this);
}
