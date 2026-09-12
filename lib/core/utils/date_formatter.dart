import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String formatHour(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      return DateFormat('h a').format(dateTime);
    } catch (_) {
      return isoTime;
    }
  }

  static String formatDayOfWeek(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      final now = DateTime.now();
      if (dateTime.year == now.year &&
          dateTime.month == now.month &&
          dateTime.day == now.day) {
        return 'Today';
      }
      return DateFormat('EEE, d').format(dateTime);
    } catch (_) {
      return isoDate;
    }
  }

  static String formatShortDay(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('E').format(dateTime).substring(0, 1);
    } catch (_) {
      return 'D';
    }
  }

  static String formatTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime);
      return DateFormat('h:mm a').format(dateTime);
    } catch (_) {
      return isoTime;
    }
  }
}
