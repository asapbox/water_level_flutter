import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:level_river/services/favorite_gauges_repository.dart';

import 'gauge.dart';
import 'water.dart';

part 'gauge_station.g.dart';

@JsonSerializable()
class GaugeStation extends Equatable {
  GaugeStation({
    required this.gauges,
    required this.slug,
    required this.location,
    required this.water,
    this.minGauge,
    this.maxGauge,
  });

  final String slug;
  final String location;
  final Water water;
  final Gauge? minGauge;
  final Gauge? maxGauge;
  @JsonKey(defaultValue: const [])
  final List<Gauge> gauges;

  @JsonKey(defaultValue: [])
  int? get diffLevelLastGauge {
    gauges.sort((a, b) => a.date.compareTo(b.date));
    final Gauge? preLastGauge;
    try {
      preLastGauge = gauges[gauges.length - 2];
    } catch (e) {
      return null;
    }
    final lastGauge = gauges.last;
    return (lastGauge.level ?? 0) - (preLastGauge.level ?? 0);
  }

  String? get diffLevelLastGaugeText {
    if (diffLevelLastGauge == null) return null;
    return '${diffLevelLastGauge! > 0 ? '+' : ''} $diffLevelLastGauge';
  }

  Gauge? get lastGauge {
    gauges.sort((a, b) => a.date.compareTo(b.date));
    try {
      return gauges.last;
    } catch (e) {
      return null;
    }
  }

  int? get lastLevel {
    return lastGauge?.level;
  }

  bool? get isLastLevelUp {
    return lastLevel != null ? lastLevel! > 0 : null;
  }

  bool get isFavorite => FavoriteGaugesRepository.isFavorite(this);

  factory GaugeStation.fromJson(Map<String, dynamic> json) => _$GaugeStationFromJson(json);

  Map<String, dynamic> toJson() => _$GaugeStationToJson(this);

  @override
  List<Object?> get props => [slug];
}
