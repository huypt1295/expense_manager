import 'package:flutter_resource/flutter_resource.dart';

/// Collection of helper utilities for common `DateTime` conversions and parsing.
class DateTimeUtils {
  DateTimeUtils._();

  /// Returns the rounded number of days between [from] and [to], ignoring
  /// the time components of the input dates.
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);

    return (to.difference(from).inHours / 24).round();
  }

  /// Returns the device timezone offset in hours relative to UTC.
  static int timezoneOffset() {
    return DateTime.now().timeZoneOffset.inHours;
  }

  /// Converts a UTC timestamp (in milliseconds) into a local [DateTime].
  static DateTime toLocalFromTimestamp({required int utcTimestampMillis}) {
    return DateTime.fromMillisecondsSinceEpoch(utcTimestampMillis, isUtc: true).toLocal();
  }

  /// Converts a local timestamp (in milliseconds) into a UTC [DateTime].
  static DateTime toUtcFromTimestamp(int localTimestampMillis) {
    return DateTime.fromMillisecondsSinceEpoch(localTimestampMillis, isUtc: false).toUtc();
  }

  /// Returns the start of the current day using the device's local timezone.
  static DateTime startTimeOfDate() {
    final now = DateTime.now();

    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

  /// Attempts to parse [dateTimeString] into a [DateTime], optionally forcing
  /// the resulting value to UTC.
  static DateTime? toDateTime(String dateTimeString, {bool isUtc = false}) {
    final dateTime = DateTime.tryParse(dateTimeString);
    if (dateTime != null) {
      if (isUtc) {
        return DateTime.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );
      }

      return dateTime;
    }

    return null;
  }

  /// Parses a [dateTimeString] by prefixing with an epoch-friendly date to
  /// normalize incomplete values, optionally returning a UTC result.
  static DateTime? toNormalizeDateTime(String dateTimeString, {bool isUtc = false}) {
    final dateTime = DateTime.tryParse('-123450101 $dateTimeString');
    if (dateTime != null) {
      if (isUtc) {
        return DateTime.utc(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          dateTime.hour,
          dateTime.minute,
          dateTime.second,
          dateTime.millisecond,
          dateTime.microsecond,
        );
      }

      return dateTime;
    }

    return null;
  }

  /// Tries to parse a date string with an optional format and locale.
  ///
  /// When [format] is omitted the string is parsed using
  /// [DateTime.tryParse]. Returns `null` if parsing fails.
  static DateTime? tryParse({
    String? date,
    String? format,
    String locale = LocaleConstants.defaultLocale,
  }) {
    if (date == null) {
      return null;
    }

    if (format == null) {
      return DateTime.tryParse(date);
    }

    final DateFormat dateFormat = DateFormat(format, locale);
    try {
      return dateFormat.parse(date);
    } catch (e) {
      return null;
    }
  }
}

/// Extension that provides convenience formatting and derived values on [DateTime].
extension DateTimeExtensions on DateTime {
  /// Formats this [DateTime] using the provided [format] string.
  String toStringWithFormat(String format) {
    return DateFormat(format).format(this);
  }

  /// Returns the last day of the month for this [DateTime].
  DateTime get lastDateOfMonth {
    return DateTime(year, month + 1, 0);
  }
}
