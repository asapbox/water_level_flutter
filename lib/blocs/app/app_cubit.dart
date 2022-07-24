import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:level_river/models/gauge_station.dart';
import 'package:level_river/repositories/gauge_repository.dart';

part 'app_cubit.g.dart';

part 'app_state.dart';

class AppCubit extends HydratedCubit<AppState> {
  final GaugeRepository _repository;

  AppCubit({required repository})
      : _repository = repository,
        super(AppState());

  void addFavorite(GaugeStation gaugeStation) {
    final items = (state.favoriteGaugeStations + [gaugeStation]).toSet().toList();
    emit(state.copyWith(observedGaugeStations: items));
  }

  void removeFavorite(GaugeStation gaugeStation) {
    final items = state.favoriteGaugeStations.where((g) => g.slug != gaugeStation.slug).toList();
    emit(state.copyWith(observedGaugeStations: items));
  }

  bool isFavorite(GaugeStation gaugeStation) {
    final items = state.favoriteGaugeStations;
    try {
      items.firstWhere((g) => g.slug == gaugeStation.slug);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateFavorites() async {
    final items = state.favoriteGaugeStations;
    final slugs = items.map((g) => g.slug).toList();
    List<GaugeStation> gaugeStations = [];
    if (slugs.isNotEmpty)
      gaugeStations = await _repository.fetchGaugeStations(
        slugs: slugs,
        first: 100,
      );
    emit(state.copyWith(observedGaugeStations: gaugeStations));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) => AppState.fromJson(json);

  @override
  Map<String, dynamic> toJson(AppState state) => state.toJson();
}
