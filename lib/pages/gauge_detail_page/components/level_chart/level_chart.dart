import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:level_river/generated/l10n.dart';
import 'package:level_river/models/gauge_station.dart';
import 'package:level_river/themes.dart';

import '../../../../models/year_chart.dart';
import '../../blocs/gauge_cubit.dart';

part 'border_extensions.dart';

part 'grid_extension.dart';

part 'spots_extension.dart';

part 'titles_extension.dart';

part 'tooltip_extensions.dart';

enum ChartDateRange { month, year }

class LevelChart extends StatefulWidget {
  final GaugeStation gaugeStation;

  const LevelChart({Key? key, required this.gaugeStation}) : super(key: key);

  @override
  _LevelChartState createState() => _LevelChartState();
}

class _LevelChartState extends State<LevelChart> {
  ThemeData get theme => Theme.of(context);

  GaugeCubit get gaugeCubit => context.read<GaugeCubit>();

  GaugeCubit get gaugeCubitBuild => context.watch<GaugeCubit>();

  Set<String> selectedYears = {};
  final List<Color> colors = [
    Colors.amber.shade300,
    Colors.purple.shade400,
    Colors.green.shade400,
    Colors.lightBlue.shade400,
    Colors.red.shade400,
  ];

  int fromDayOfYear = 0;

  ChartDateRange _selectedDateRange = ChartDateRange.month;

  String? _selectedGauge;
  bool showSelectedGaugeDate = false;

  final graphColor = Colors.blue.shade300;

  GaugeStation get gaugeStation => widget.gaugeStation;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    fetchData();
  }

  fetchData() async {
    await gaugeCubit.fetchGauges(
      gaugeStationSlug: gaugeStation.slug,
      dateFrom: DateTime.now().subtract(Duration(days: 2000)),
      dateTo: DateTime.now(),
    );
    for (final y in gaugeCubit.state.years) {
      selectedYears.add(y.year);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Colors.grey.shade800),
        _buildRanges(),
        // Divider(color: Colors.grey),
        Container(height: 10.0),
        buildChart(),
        Container(
          height: 20,
          child: showSelectedGaugeDate ? _buildTitle() : null,
        ),
        Container(height: 10.0),
        _buildYears(),
      ],
    );
  }

  _buildYears() {
    final List<Widget> children = [];
    for (var i = 0; i < gaugeCubitBuild.state.years.length; i++) {
      final year = gaugeCubitBuild.state.years[i];
      final color = colors[i];
      final item = FilterChip(
        key: Key(year.year),
        label: Text(
          year.year,
          style: TextStyle(color: color),
        ),
        selected: selectedYears.contains(year.year),
        onSelected: (v) {
          if (v)
            selectedYears.add(year.year);
          else
            selectedYears.remove(year.year);
          setState(() {});
        },
      );
      children.add(item);
    }
    return Wrap(
      direction: Axis.horizontal,
      spacing: 10.0,
      children: children,
      runSpacing: 10.0,
    );
  }

  _buildRanges() {
    final style = Theme.of(context).textTheme.bodyText1;
    final Map<ChartDateRange, String> rangeTitles = {
      ChartDateRange.month: S.of(context).month,
      ChartDateRange.year: S.of(context).year,
    };
    final List<Widget> children = [];
    rangeTitles.forEach((key, value) {
      children.add(
        ChoiceChip(
          selected: key == _selectedDateRange,
          onSelected: (v) => _onTapRange(key),
          label: Text(value, style: style),
          backgroundColor: Colors.transparent,
          selectedColor: theme.chipTheme.backgroundColor,
        ),
      );
    });
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: children,
      ),
    );
  }

  _onTapRange(ChartDateRange r) {
    _selectedDateRange = r;
    setState(() {});
  }

  _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedGauge ?? '',
          style: theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  buildChart() {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: AspectRatio(
        aspectRatio: 1.2,
        child: MouseRegion(
          onHover: (v) => _showSelectedDate(),
          onExit: (v) => _hideSelectedDate(),
          child: Listener(
            onPointerUp: (v) => _hideSelectedDate(),
            onPointerCancel: (v) => _hideSelectedDate(),
            onPointerDown: (v) => _showSelectedDate(),
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: LineChart(
                buildChartData(),
                swapAnimationDuration: Duration.zero, // Optional
                swapAnimationCurve: Curves.linear, // Optional
              ),
            ),
          ),
        ),
      ),
    );
  }

  _showSelectedDate() {
    if (!showSelectedGaugeDate)
      setState(() {
        showSelectedGaugeDate = true;
      });
  }

  _hideSelectedDate() {
    setState(() {
      showSelectedGaugeDate = false;
    });
  }

  buildChartData() {
    return LineChartData(
      lineTouchData: _getLineTouchData(),
      lineBarsData: _buildChartBarsData(),
      borderData: _buildBorderData(),
      gridData: getGridData(),
      titlesData: _getTitlesData(),
      backgroundColor: Colors.transparent,
    );
  }

  _touchCallback(FlTouchEvent event, LineTouchResponse? touchResponse) {
    final index = touchResponse?.lineBarSpots?[0].spotIndex ?? 1;

    var dayOfYear = index + fromDayOfYear;
    var millisDayOfYear = dayOfYear * 86400000;
    var millisecondsSinceEpoch = DateTime(DateTime.now().year).millisecondsSinceEpoch;
    var dayOfYearDate =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch + millisDayOfYear);

    final dateText = DateFormat('d MMM').format(dayOfYearDate.toLocal());
    _selectedGauge = '$dateText';
    setState(() {});
  }

  List<LineChartBarData> _buildChartBarsData() {
    List<LineChartBarData> bars = [];
    for (var i = 0; i < gaugeCubitBuild.state.years.length; i++) {
      final year = gaugeCubitBuild.state.years[i];
      final color = colors[i];
      final bool show = selectedYears.contains(year.year);
      final bar = LineChartBarData(
        show: show,
        curveSmoothness: 1.0,
        spots: _buildYearSpots(year),
        // isCurved: true,
        barWidth: 2,
        color: color,
        dotData: FlDotData(
          show: true,
          getDotPainter: (FlSpot spot, percent, barData, index) => FlDotCirclePainter(
            radius: 1,
            color: barData.color,
            strokeColor: Colors.transparent,
            strokeWidth: 0,
          ),
        ),
        belowBarData: BarAreaData(
          show: show,
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.5),
              color.withOpacity(0.0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      );

      bars.add(bar);
    }
    return bars;
  }
}
