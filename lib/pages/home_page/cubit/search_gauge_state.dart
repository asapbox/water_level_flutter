part of 'search_gauge_cubit.dart';

class SearchGaugeState extends Equatable {
  final SearchGaugeInput query;
  final FormzStatus status;
  final List<GaugeStation> items;

  SearchGaugeState({
    this.status = FormzStatus.pure,
    this.query = const SearchGaugeInput.pure(),
    this.items = const [],
  });

  @override
  List<Object> get props => [query, status];

  SearchGaugeState copyWith({
    FormzStatus? status,
    SearchGaugeInput? query,
    List<GaugeStation>? items,
  }) {
    return SearchGaugeState(
      status: status ?? this.status,
      query: query ?? this.query,
      items: items ?? this.items,
    );
  }
}
