import 'package:flutter/material.dart';

Future<DateTime?> selectDate(BuildContext context, DateTime initial) {
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
  );
}

String formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final expenseDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  final hour = dateTime.hour;
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
  final timeString = '$displayHour:$minute $period';

  if (expenseDate == today) return 'Today $timeString';
  if (expenseDate == yesterday) return 'Yesterday $timeString';

  const monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${monthNames[dateTime.month - 1]} ${dateTime.day} $timeString';
}

String getFormattedDate(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final expenseDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (expenseDate == today) return 'Today';
  if (expenseDate == yesterday) return 'Yesterday';

  return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
}
