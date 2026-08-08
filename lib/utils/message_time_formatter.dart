String formatDateLabel(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final targetDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (targetDay == today) {
    return 'Today';
  }

  if (targetDay == today.subtract(const Duration(days: 1))) {
    return 'Yesterday';
  }

  return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
}

String formatTimestamp(DateTime dateTime) {
  final hour = dateTime.hour % 12;
  final hourText = hour == 0 ? 12 : hour;
  final minuteText = dateTime.minute.toString().padLeft(2, '0');
  final meridiem = dateTime.hour >= 12 ? 'PM' : 'AM';
  return '$hourText:$minuteText $meridiem';
}
