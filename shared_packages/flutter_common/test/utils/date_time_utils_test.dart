import 'package:flutter_common/src/utils/date_time_utils.dart';
import 'package:flutter_resource/flutter_resource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {

  setUpAll(() async {
    await initializeDateFormatting(LocaleConstants.defaultLocale, null);
  });

  group('DateTimeUtils.daysBetween', () {
    test('ignores time component and rounds the result', () {
      final from = DateTime(2024, 1, 1, 23, 15);
      final to = DateTime(2024, 1, 3, 1, 0);

      expect(DateTimeUtils.daysBetween(from, to), 2);
    });
  });

  group('DateTimeUtils.timezoneOffset', () {
    test('matches DateTime.now timeZoneOffset', () {
      final nowOffset = DateTime.now().timeZoneOffset.inHours;

      expect(DateTimeUtils.timezoneOffset(), nowOffset);
    });
  });

  group('DateTimeUtils timestamp conversions', () {
    test('toLocalFromTimestamp converts UTC epoch to local time', () {
      final timestamp = DateTime.utc(2024, 2, 4, 12, 30).millisecondsSinceEpoch;
      final expected =
          DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true).toLocal();

      expect(DateTimeUtils.toLocalFromTimestamp(utcTimestampMillis: timestamp),
          expected);
    });

    test('toUtcFromTimestamp converts local epoch to UTC time', () {
      final localDate = DateTime(2024, 2, 4, 12, 30);
      final timestamp = localDate.millisecondsSinceEpoch;
      final expected = DateTime.fromMillisecondsSinceEpoch(timestamp).toUtc();

      expect(DateTimeUtils.toUtcFromTimestamp(timestamp), expected);
    });
  });

  group('DateTimeUtils.startTimeOfDate', () {
    test('resets the time to the start of the day', () {
      final result = DateTimeUtils.startTimeOfDate();
      final now = DateTime.now();

      expect(result.year, now.year);
      expect(result.month, now.month);
      expect(result.day, now.day);
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
      expect(result.millisecond, 0);
      expect(result.microsecond, 0);
    });
  });

  group('DateTimeUtils.toDateTime', () {
    test('parses a datetime string', () {
      final dateTime = DateTimeUtils.toDateTime('2024-03-05T10:11:12');

      expect(dateTime, DateTime.parse('2024-03-05T10:11:12'));
    });

    test('parses a datetime string and forces UTC', () {
      final dateTime =
          DateTimeUtils.toDateTime('2024-03-05 10:11:12', isUtc: true);

      expect(dateTime, DateTime.utc(2024, 3, 5, 10, 11, 12));
    });

    test('returns null for invalid input', () {
      expect(DateTimeUtils.toDateTime('invalid'), isNull);
    });
  });

  group('DateTimeUtils.toNormalizeDateTime', () {
    test('parses partial time input', () {
      final dateTime = DateTimeUtils.toNormalizeDateTime('15:30:45');

      expect(dateTime, isNotNull);
      expect(dateTime?.hour, 15);
      expect(dateTime?.minute, 30);
      expect(dateTime?.second, 45);
    });

    test('parses partial time input and forces UTC', () {
      final dateTime =
          DateTimeUtils.toNormalizeDateTime('15:30:45', isUtc: true);

      expect(dateTime, isNotNull);
      expect(dateTime?.isUtc, isTrue);
    });

    test('returns null for invalid input', () {
      expect(DateTimeUtils.toNormalizeDateTime('invalid time'), isNull);
    });
  });

  group('DateTimeUtils.tryParse', () {
    // initializeDateFormatting('vi', '') can be added here if locale-specific
    // parsing is required.

    test('parses date using DateTime.tryParse when format is not provided', () {
      final date = DateTimeUtils.tryParse(date: '2024-06-01T00:00:00');

      expect(date, DateTime.parse('2024-06-01T00:00:00'));
    });

    test('parses date using provided format and locale', () {
      final date =
          DateTimeUtils.tryParse(date: '01/06/2024', format: 'dd/MM/yyyy');

      expect(date, DateTime(2024, 6, 1));
    });

    test('returns null when date cannot be parsed', () {
      expect(DateTimeUtils.tryParse(date: 'not a date', format: 'dd/MM/yyyy'),
          isNull);
    });

    test('returns null when date is null', () {
      expect(DateTimeUtils.tryParse(), isNull);
    });
  });

  group('DateTimeExtensions', () {
    test('formats date time using provided format', () {
      final date = DateTime(2024, 7, 8, 9, 10, 11);

      expect(date.toStringWithFormat(DateFormat.MMMd()), '2024-07-08');
    });

    test('returns last date of month', () {
      final date = DateTime(2024, 2, 10);

      expect(date.lastDateOfMonth, DateTime(2024, 3, 0));
    });
  });
}
