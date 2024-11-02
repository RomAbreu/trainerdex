import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static getAppTheme() {
    return ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: GoogleFonts.manrope().fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorSchemeSeed: const Color(0xFFFFFFFF));
  }
}
