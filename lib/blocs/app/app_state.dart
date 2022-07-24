part of 'app_cubit.dart';

@JsonSerializable()
class AppState extends Equatable {
  final List<GaugeStation> favoriteGaugeStations;

  AppState({this.favoriteGaugeStations = const []});

  @override
  List<Object?> get props => [favoriteGaugeStations];

  AppState copyWith({List<GaugeStation>? observedGaugeStations}) {
    return AppState(
      favoriteGaugeStations: observedGaugeStations ?? this.favoriteGaugeStations,
    );
  }

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  @override
  String toString() {
    return '{ favoriteGaugeStations: $favoriteGaugeStations }';
  }
}
