// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
      favoriteGaugeStations: (json['favoriteGaugeStations'] as List<dynamic>?)
              ?.map((e) => GaugeStation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'favoriteGaugeStations': instance.favoriteGaugeStations,
    };
