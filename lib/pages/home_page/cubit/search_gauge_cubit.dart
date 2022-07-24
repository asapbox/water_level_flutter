import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:level_river/models/gauge_station.dart';
import 'package:level_river/repositories/gauge_repository.dart';
import 'package:level_river/utils/forms_input/search_gauge.dart';
import 'package:rxdart/rxdart.dart';

part 'search_gauge_state.dart';

class SearchGaugeCubit extends Cubit<SearchGaugeState> {
  final GaugeRepository _gaugeRepository;
  final StreamController<SearchGaugeState> _queryDebouncer = StreamController<SearchGaugeState>();

  SearchGaugeCubit({required gaugeRepository})
      : _gaugeRepository = gaugeRepository,
        super(SearchGaugeState()) {
    _queryDebouncer.stream.debounceTime(const Duration(milliseconds: 300)).listen((e) {
      search();
    });
  }

  @override
  Future<void> close() {
    return Future.wait([
      _queryDebouncer.close(),
      super.close(),
    ]);
  }

  queryChanged(String value) {
    final query = SearchGaugeInput.dirty(value);
    _changeQuery(state.copyWith(
      query: query,
      status: Formz.validate([query]),
    ));
  }

  search() async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final results = await _gaugeRepository.searchGaugeStations(query: state.query.value.trim());
      emit(state.copyWith(items: results, status: FormzStatus.submissionSuccess));
    } else
      cleanSearch();
  }

  cleanSearch() {
    emit(SearchGaugeState());
  }

  void _changeQuery(SearchGaugeState newState) {
    if (state == newState) return;
    emit(newState);
    _queryDebouncer.add(state);
  }
}
