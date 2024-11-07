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

  static final Map<String, Color> typeColors = {
    'normal': const Color(0x00A8A77A),
    'fire': const Color(0x00EE8130),
    'water': const Color(0x0039A9DB),
    'electric': const Color(0x00F7D02C),
    'grass': const Color(0x00A7DB8D),
    'ice': const Color(0x0096D9D6),
    'fighting': const Color(0x00C22E28),
    'poison': const Color(0x00A33EA1),
    'ground': const Color(0x00E2BF65),
    'flying': const Color(0x00A98FF3),
    'psychic': const Color(0x00F95587),
    'bug': const Color(0x00A6B91A),
    'rock': const Color(0x00B6A136),
    'ghost': const Color(0x006F5797),
    'dragon': const Color(0x00A27DFA),
    'dark': const Color(0x0054534F),
    'steel': const Color(0x00B7B7CE),
    'fairy': const Color(0x00D685AD),
  };
}
