extension ListExtension<T> on List<T> {
  List<T> slice(int start, [int? end]) {
    int _start = start.isNegative ? this.length + start : start;
    int _end = end != null
        ? end.isNegative
            ? this.length + end
            : end
        : this.length;
    return this.sublist(_start, _end);
  }
}

extension DateTimeExtension on DateTime {
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ??= this.year,
      month ??= this.month,
      day ??= this.day,
      hour ??= this.hour,
      minute ??= this.minute,
      second ??= this.second,
      millisecond ??= this.millisecond,
      microsecond ??= this.microsecond,
    );
  }
}
