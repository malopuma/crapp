// lib/themes/app_theme_dark.dart

import 'package:flutter/material.dart';

class AppThemeDark {
  final Color appbackgroundColor = Colors.blueGrey.shade700;
  final Color appforegroundColor = Colors.blueGrey.shade900;
  final Color accentColor1 = Colors.blueAccent.shade400;

  final TextStyle fontStyleWidgetNote = TextStyle(
    fontSize: 12,
    color: Colors.blueGrey.shade400,
    fontWeight: FontWeight.normal,
  );

  final TextStyle fontStyleWidgetOutput = TextStyle(
    fontSize: 32,
    color: Colors.blueGrey.shade200,
    fontWeight: FontWeight.bold,
  );

  final TextStyle fontStyleWidgetText = TextStyle(
    fontSize: 32,
    color: Colors.blueGrey.shade400,
    fontWeight: FontWeight.bold,
  );

  final TextStyle fontStyleWidgetTextHiglight = TextStyle(
    fontSize: 32,
    color: Colors.amber,
    fontWeight: FontWeight.bold,
  );

}