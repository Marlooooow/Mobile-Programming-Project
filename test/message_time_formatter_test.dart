import 'package:flutter_test/flutter_test.dart';
import 'package:aida/utils/message_time_formatter.dart';

void main() {
  test('returns Today for the current day', () {
    final now = DateTime.now();
    expect(formatDateLabel(now), 'Today');
  });

  test('returns Yesterday for the previous day', () {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    expect(formatDateLabel(yesterday), 'Yesterday');
  });

  test('formats a timestamp as time with meridiem', () {
    final timestamp = DateTime(2026, 8, 4, 21, 5);
    expect(formatTimestamp(timestamp), '9:05 PM');
  });
}
