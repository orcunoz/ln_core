import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  ContexedDateTime of(BuildContext context) => ContexedDateTime(context, this);

  DateTime withTime(TimeOfDay time) =>
      DateTime(year, month, day, time.hour, time.minute);

  TimeOfDay get timeOfDay => TimeOfDay.fromDateTime(this);

  String toTimeString() {
    String addLeadingZeroIfNeeded(int value) =>
        value < 10 ? '0$value' : value.toString();

    return "${addLeadingZeroIfNeeded(hour)}"
        ":${addLeadingZeroIfNeeded(minute)}"
        ":${addLeadingZeroIfNeeded(second)}";
  }

  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
    bool? isUtc,
  }) {
    return ((isUtc ?? this.isUtc) ? DateTime.utc : DateTime.new)(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

extension TimeOfDayExtensions on TimeOfDay {
  String toTimeString() {
    String addLeadingZeroIfNeeded(int value) =>
        value < 10 ? '0$value' : value.toString();

    return '${addLeadingZeroIfNeeded(hour)}:${addLeadingZeroIfNeeded(minute)}';
  }

  DateTime withDate(DateTime date) => date.withTime(this);
}

class ContexedDateTime {
  final BuildContext context;
  final DateTime date;

  ContexedDateTime(this.context, this.date);

  String get _languageCode => Localizations.localeOf(context).languageCode;

  String get monthNameShort => DateFormat.MMM(_languageCode).format(date);

  String get monthName => DateFormat.MMMM(_languageCode).format(date);

  String get dayNameOfWeek => DateFormat.E(_languageCode).format(date);

  String get dateString => DateFormat.yMMMd(_languageCode).format(date);

  TimeOfDay get toTime => TimeOfDay.fromDateTime(date);

  String get timeString => toTime.format(context);

  String get dateTimeString => "$dateString $timeString";
}
