import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

TextTheme createTextTheme(
  BuildContext context,
  String bodyFontString,
  String displayFontString,
) {
  TextTheme baseTextTheme = Theme.of(context).textTheme;
  TextTheme bodyTextTheme = GoogleFonts.getTextTheme(
    bodyFontString,
    baseTextTheme,
  );
  TextTheme displayTextTheme = GoogleFonts.getTextTheme(
    displayFontString,
    baseTextTheme,
  );
  TextTheme textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
  );
  return textTheme;
}

Map<String, dynamic> formatTaskDate(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final inputDate = DateTime(date.year, date.month, date.day);
  final difference = inputDate.difference(today).inDays;
  final isOverdue = difference < 0;

  if (difference == 0) {
    return {'text': 'Today', 'color': Colors.green};
  } else if (difference == 1) {
    return {'text': 'Tomorrow', 'color': null};
  } else if (difference == -1) {
    return {'text': 'Yesterday', 'color': Colors.red};
  } else if (difference < 7 && difference > 1) {
    return {'text': DateFormat('E').format(date), 'color': null};
  } else if (date.year == now.year) {
    return {
      'text': DateFormat('dd MMM').format(date),
      'color': isOverdue ? Colors.red : null,
    };
  } else {
    return {
      'text': DateFormat('dd MMM yyyy').format(date),
      'color': isOverdue ? Colors.red : null,
    };
  }
}
