import 'dart:ui' as ui show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:level_river/blocs/app/app_cubit.dart';
import 'package:level_river/generated/l10n.dart';
import 'package:level_river/models/gauge_station.dart';
import 'package:level_river/pages/gauge_detail_page/gauge_detail_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../cubit/search_gauge_cubit.dart';
import 'gauge_card.dart';

class SearchGaugeView extends StatefulWidget {
  const SearchGaugeView({Key? key}) : super(key: key);

  @override
  _SearchGaugeViewState createState() => _SearchGaugeViewState();
}

class _SearchGaugeViewState extends State<SearchGaugeView> {
  ThemeData get theme => Theme.of(context);

  late FocusNode _searchFocusNode;
  bool _searchActive = false;

  final _searchController = TextEditingController();

  AppCubit get appCubit => context.read<AppCubit>();

  AppCubit get appCubitBuild => context.watch<AppCubit>();
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(_onChangeSearchFocus);
    appCubit.updateFavorites();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.clear();
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchBackGround = theme.scaffoldBackgroundColor;
    return BlocBuilder<SearchGaugeCubit, SearchGaugeState>(
      builder: (context, SearchGaugeState state) {
        return Scaffold(
          appBar: AppBar(
            title: _buildSearchForm(),
            backgroundColor: theme.scaffoldBackgroundColor,
            shadowColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              AbsorbPointer(
                absorbing: _searchActive,
                child: _buildGaugeStations(),
              ),
              if (_searchActive)
                GestureDetector(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      child: _buildSearchResult(state),
                      color: state.items.isEmpty ? searchBackGround.withOpacity(0.5) : searchBackGround,
                    ),
                  ),
                  onTap: () {
                    if (state.query.value.isEmpty) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      _searchActive = false;
                      setState(() {});
                    }
                  },
                ),
              // buildOnSearch(),
            ],
          ),
        );
      },
    );
  }

  _buildSearchForm() {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CupertinoSearchTextField(
            controller: _searchController,
            onChanged: (value) => context.read<SearchGaugeCubit>().queryChanged(value),
            focusNode: _searchFocusNode,
            style: theme.textTheme.bodyText1!.copyWith(fontSize: 16),
            placeholder: S.of(context).searchHomePage,
          ),
        ),
        if (_searchActive)
          TextButton(
            onPressed: () => _onCancelSearch(context),
            child: Text(S.of(context).cancel, style: TextStyle(fontSize: 14)),
          )
      ],
    );
    // return Row(
    //   children: [
    //     Icon(Icons.search),
    //     Expanded(
    //       child: TextField(),
    //     ),
    //
    //   ],
    // );
  }

  _buildSearchResult(state) {
    List<Widget> children = [];
    for (final g in state.items) {
      children.addAll([
        GaugeCard(
          gaugeStation: g,
          onTap: _onTapGaugeStationCardHandler,
          showChart: false,
        ),
        Divider(
          thickness: 0.5,
          height: 0.0,
        ),
      ]);
    }
    return ListView(children: children);
  }

  _onCancelSearch(BuildContext context) {
    _searchFocusNode.unfocus();
    _searchActive = false;
    context.read<SearchGaugeCubit>().cleanSearch();
    _searchController.clear();
    setState(() {});
  }

  _onChangeSearchFocus() {
    if (!_searchActive && _searchFocusNode.hasFocus) {
      _searchActive = true;
      setState(() {});
    }
  }

  _buildGaugeStations() {
    List<Widget> children = [];
    const divider = Divider(thickness: 0.5, height: 0);
    for (final GaugeStation g in appCubitBuild.state.favoriteGaugeStations) {
      children.addAll([_buildGaugeStation(g), divider]);
    }
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: false,
      enablePullDown: true,
      onRefresh: _onRefresh,
      header: ClassicHeader(refreshStyle: RefreshStyle.Follow),
      child: ListView(
        padding: EdgeInsets.zero,
        children: children,
      ),
    );
  }

  void _onRefresh() async {
    appCubit.updateFavorites();
    _refreshController.refreshCompleted();
  }

  _buildGaugeStation(GaugeStation gaugeStation) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      child: GaugeCard(
        key: ValueKey(gaugeStation.slug),
        gaugeStation: gaugeStation,
        onTap: _onTapGaugeStationCardHandler,
      ),
      background: Container(
        padding: const EdgeInsets.only(right: 20.0),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
            Text(
              S.of(context).delete,
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
      onDismissed: (v) => _removeFavoriteHandle(gaugeStation),
    );
  }

  _onTapGaugeStationCardHandler(GaugeStation gaugeStation) async {
    Navigator.of(context).pushNamed(
      GaugeStationDetailPage.routeName,
      arguments: GaugeStationDetailPageArgs(
        gaugeStation: gaugeStation,
        onTapAddFavorite: appCubit.addFavorite,
      ),
    );
  }

  void _removeFavoriteHandle(GaugeStation gaugeStation) async {
    appCubit.removeFavorite(gaugeStation);
  }
}
