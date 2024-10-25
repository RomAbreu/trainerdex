import 'package:flutter/material.dart';

class AppTheme {
  static getAppTheme() {
    return ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorSchemeSeed: const Color(0xFFFFFFFF));
  }
}
