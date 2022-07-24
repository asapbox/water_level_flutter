part of 'gauge_cubit.dart';

class GaugeState extends Equatable {
  final List<Gauge> gauges;
  final List<YearChart> years;

  GaugeState({this.gauges = const [], this.years = const []});

  @override
  List<Object?> get props => [gauges];
}
