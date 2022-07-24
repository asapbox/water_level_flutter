// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ios_widget_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IosWidgetData _$IosWidgetDataFromJson(Map<String, dynamic> json) =>
    IosWidgetData(
      title: json['title'] as String,
      subTitle: json['subTitle'] as String,
      level: json['level'] as String,
      diffLevelText: json['diffLevelText'] as String,
      levels: (json['levels'] as List<dynamic>).map((e) => e as int).toList(),
      increaseLevel: json['increaseLevel'] as bool,
    );

Map<String, dynamic> _$IosWidgetDataToJson(IosWidgetData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subTitle': instance.subTitle,
      'levels': instance.levels,
      'level': instance.level,
      'diffLevelText': instance.diffLevelText,
      'increaseLevel': instance.increaseLevel,
    };
