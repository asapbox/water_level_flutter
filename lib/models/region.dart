import 'package:json_annotation/json_annotation.dart';


part 'region.g.dart';

@JsonSerializable()
class Region {
  Region({required this.slug, required this.name});

  final String slug;
  final String name;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

  Map<String, dynamic> toJson() => _$RegionToJson(this);
}
