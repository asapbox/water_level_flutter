part of 'level_chart.dart';

extension TitlesExtension on _LevelChartState {
  _getTitlesData() {
    final styleSideTitle =
        theme.textTheme.bodyText1!.copyWith(fontWeight: FontWeight.bold, fontSize: 12);
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          reservedSize: 30,
          interval: 1,
          getTitlesWidget: (value, titleMeta) {
            return Text(value.toString());
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (double value, titleMeta) {
              final _value = '${(value / 100).round()} ${S.of(context).meterShort}';
              if (value.remainder(100) != 0) return Container();
              return Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(_value, style: styleSideTitle),
              );
            }),
      ),
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }
}
