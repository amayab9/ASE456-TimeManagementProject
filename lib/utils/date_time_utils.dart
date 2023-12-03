import 'package:cloud_firestore/cloud_firestore.dart';

class DateTimeUtils {
  static String formatTimestamp(DateTime dateTime) {
    return _formatDateTime(dateTime);
  }

  static String formatTime(Timestamp timestamp) {
    DateTime time = timestamp.toDate();
    return _formatDateTime(time);
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static bool isValidDateFormat(String date) {
    RegExp dateRegExp = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    return dateRegExp.hasMatch(date);
  }
}
