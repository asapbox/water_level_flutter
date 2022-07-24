// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'water.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Water _$WaterFromJson(Map<String, dynamic> json) => Water(
      slug: json['slug'] as String,
      name: json['name'] as String,
      region: Region.fromJson(json['region'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WaterToJson(Water instance) => <String, dynamic>{
      'slug': instance.slug,
      'name': instance.name,
      'region': instance.region,
    };
