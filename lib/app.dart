import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_widgetkit/flutter_widgetkit.dart';

import 'blocs/app/app_cubit.dart';
import 'blocs/theme/theme_cubit.dart';
import 'generated/l10n.dart';
import 'pages/home_page/home_page.dart';
import 'repositories/gauge_repository.dart';
import 'routes.dart';
import 'services/favorite_gauges_repository.dart';
import 'services/graphql_provider.dart';
import 'services/persistent_storage.dart';
import 'themes.dart';

class MyApp extends StatefulWidget {
  final PersistentStorage storage;

  const MyApp({Key? key, required this.storage}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final ThemeCubit themeCubit;
  late final AppCubit appCubit;
  late final GraphqlProvider graphqlProvider;
  late final GaugeRepository gaugeRepository;

  @override
  void initState() {
    super.initState();
    graphqlProvider = GraphqlProvider();
    gaugeRepository = GaugeRepository(graphqlProvider: graphqlProvider);
    appCubit = AppCubit(repository: gaugeRepository);
    FavoriteGaugesRepository(appCubit);
    appCubit.updateFavorites();
    if (!kIsWeb && Platform.isIOS) initIosWidget();
  }

  @override
  void dispose() {
    themeCubit.clear();
    appCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = widget.storage;
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PersistentStorage>.value(value: storage),
        RepositoryProvider<GraphqlProvider>.value(value: graphqlProvider),
        RepositoryProvider<GaugeRepository>.value(value: gaugeRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: _createThemeCubit),
          BlocProvider<AppCubit>.value(value: appCubit),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, ThemeState state) {
            return MaterialApp(
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              navigatorKey: _navigatorKey,
              theme: CustomTheme.lightTheme,
              darkTheme: CustomTheme.darkTheme,
              themeMode: ThemeMode.system,
              home: HomePage(),
              onGenerateRoute: RouterProvider.onGenerateRoute,
            );
          },
        ),
      ),
    );
  }

  ThemeCubit _createThemeCubit(BuildContext context) {
    return ThemeCubit();
  }

  // AppCubit _createAppCubit(BuildContext context) {
  //   final appCubit = AppCubit();
  //   FavoriteGaugesRepository(appCubit);
  //   return appCubit;
  // }

  initIosWidget() async {
    WidgetKit.reloadAllTimelines();
  }
}
