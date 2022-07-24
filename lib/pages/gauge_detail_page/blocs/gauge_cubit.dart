import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:level_river/models/gauge.dart';
import 'package:level_river/services/graphql_provider.dart';

import '../../../models/year_chart.dart';
import '../../../repositories/gauge_repository.dart';

part 'gauge_state.dart';

class GaugeCubit extends Cubit<GaugeState> {
  final GaugeRepository repository;
  final GraphqlProvider graphqlProvider;

  GaugeCubit({required this.graphqlProvider, required this.repository}) : super(GaugeState());

  fetchGauges({
    required String gaugeStationSlug,
    required DateTime dateFrom,
    required DateTime dateTo,
    String? ordering,
  }) async {
    final gauges = await graphqlProvider.allRiverGraphqlProvider.fetchGauges(
      gaugeStationSlug: gaugeStationSlug,
      dateFrom: dateFrom,
      dateTo: dateTo,
      ordering: ordering,
    );
    final charts = await repository.fetchYearCharts(gaugeStationSlug);
    emit(GaugeState(gauges: gauges, years: charts));
  }
}
