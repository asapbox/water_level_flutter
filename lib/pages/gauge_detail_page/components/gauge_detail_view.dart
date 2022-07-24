import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:level_river/generated/l10n.dart';
import 'package:level_river/models/gauge_station.dart';

import 'level_chart/level_chart.dart';

class GaugeStationDetailView extends StatefulWidget {
  final GaugeStation gaugeStation;
  final Function(GaugeStation)? onTapAddFavorite;

  const GaugeStationDetailView({
    Key? key,
    required this.gaugeStation,
    this.onTapAddFavorite,
  }) : super(key: key);

  @override
  _GaugeStationDetailViewState createState() => _GaugeStationDetailViewState();
}

class _GaugeStationDetailViewState extends State<GaugeStationDetailView> {
  ThemeData get theme => Theme.of(context);

  final padding = const EdgeInsets.symmetric(horizontal: 20);

  GaugeStation get gaugeStation => widget.gaugeStation;

  @override
  void initState() {
    super.initState();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gaugeStation.water.name),
        titleSpacing: 10.0,
        backgroundColor: theme.scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        actions: [
          if (widget.onTapAddFavorite != null && !gaugeStation.isFavorite)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: FilterChip(
                onSelected: (v) {
                  widget.onTapAddFavorite!(gaugeStation);
                  setState(() {});
                },
                label: Text(
                  S.of(context).addToFavoriteGaugeDetailPage,
                  style: theme.textTheme.bodyText1!.copyWith(fontSize: 10),
                ),
              ),
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  padding: constraints.maxWidth > 800
                      ? const EdgeInsets.symmetric(vertical: 20.0)
                      : null,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Container(height: 10),
                      _Title(gaugeStation: gaugeStation, padding: padding),
                      Container(height: 10),
                      LevelChart(gaugeStation: gaugeStation),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final GaugeStation gaugeStation;

  final EdgeInsets padding;

  const _Title({Key? key, required this.gaugeStation, required this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diffStyleUp = theme.textTheme.bodyText2!.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: Colors.green.shade400,
    );
    final diffStyleDown = diffStyleUp.copyWith(color: Colors.redAccent);
    return Container(
      padding: padding,
      child: Wrap(
        runSpacing: 20.0,
        direction: Axis.horizontal,
        alignment: WrapAlignment.spaceBetween,
        spacing: 100,
        children: [
          Text(
            gaugeStation.location,
            style:
            theme.textTheme.headline5!.copyWith(fontWeight: FontWeight.w400, fontSize: 14),
          ),
          FittedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${gaugeStation.lastLevel} ${S.of(context).centimeterShort}',
                      style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Container(width: 20),
                    if (gaugeStation.isLastLevelUp != null)
                      Text(
                        gaugeStation.diffLevelLastGauge.toString(),
                        style: gaugeStation.isLastLevelUp! ? diffStyleUp : diffStyleDown,
                      ),
                  ],
                ),
                Container(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      gaugeStation.lastGauge?.date != null
                          ? DateFormat('dd.MM.y').format(gaugeStation.lastGauge!.date.toLocal())
                          : '-',
                      style: theme.textTheme.bodyText1!
                          .copyWith(fontWeight: FontWeight.w500, fontSize: 10),
                    ),
                    // Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
