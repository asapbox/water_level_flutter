import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:level_river/models/gauge_station.dart';
import 'package:level_river/services/graphql_provider.dart';

import '../../repositories/gauge_repository.dart';
import 'components/gauge_detail_view.dart';
import 'blocs/gauge_cubit.dart';

class GaugeStationDetailPageArgs {
  final GaugeStation gaugeStation;
  final Function(GaugeStation)? onTapAddFavorite;

  GaugeStationDetailPageArgs({required this.gaugeStation, this.onTapAddFavorite});
}

class GaugeStationDetailPage extends StatelessWidget {
  final GaugeStationDetailPageArgs arguments;

  const GaugeStationDetailPage({Key? key, required this.arguments}) : super(key: key);

  static const routeName = 'gauge_detail';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: _createGaugeCubit,
      child: GaugeStationDetailView(
        gaugeStation: arguments.gaugeStation,
        onTapAddFavorite: arguments.onTapAddFavorite,
      ),
    );
  }

  GaugeCubit _createGaugeCubit(BuildContext context) {
    return GaugeCubit(
      graphqlProvider: context.read<GraphqlProvider>(),
      repository: context.read<GaugeRepository>(),
    );
  }
}
