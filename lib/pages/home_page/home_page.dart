import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:level_river/blocs/app/app_cubit.dart';
import 'package:level_river/repositories/gauge_repository.dart';

import 'components/search_gauge.dart';
import 'cubit/search_gauge_cubit.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  ThemeData get theme => Theme.of(context);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) context.read<AppCubit>().updateFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: _createGaugeCubit,
      child: SearchGaugeView(),
    );
  }

  SearchGaugeCubit _createGaugeCubit(BuildContext context) {
    return SearchGaugeCubit(gaugeRepository: context.read<GaugeRepository>());
  }
}
