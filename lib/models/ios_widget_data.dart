import 'package:json_annotation/json_annotation.dart';

part 'ios_widget_data.g.dart';

@JsonSerializable()
class IosWidgetData {
  IosWidgetData({
    required this.title,
    required this.subTitle,
    required this.level,
    required this.diffLevelText,
    required this.levels,
    required this.increaseLevel,
  });

  final String title;
  final String subTitle;
  final List<int> levels;
  final String level;
  final String diffLevelText;
  final bool increaseLevel;

  factory IosWidgetData.fromJson(Map<String, dynamic> json) => _$IosWidgetDataFromJson(json);

  Map<String, dynamic> toJson() => _$IosWidgetDataToJson(this);
}
