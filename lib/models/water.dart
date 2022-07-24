import 'package:json_annotation/json_annotation.dart';

import 'region.dart';

part 'water.g.dart';

@JsonSerializable()
class Water {
  Water({required this.slug, required this.name, required this.region});

  final String slug;
  final String name;
  final Region region;

  factory Water.fromJson(Map<String, dynamic> json) => _$WaterFromJson(json);

  Map<String, dynamic> toJson() => _$WaterToJson(this);
}
