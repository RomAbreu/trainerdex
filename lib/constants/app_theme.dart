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
    'normal': const Color(0xFFA8A77A),
    'fire': const Color(0xFFEE8130),
    'water': const Color(0xFF39A9DB),
    'electric': const Color(0xFFF7D02C),
    'grass': const Color(0xFFA7DB8D),
    'ice': const Color(0xFF96D9D6),
    'fighting': const Color(0xFFC22E28),
    'poison': const Color(0xFFA33EA1),
    'ground': const Color(0xFFE2BF65),
    'flying': const Color(0xFFA98FF3),
    'psychic': const Color(0xFFF95587),
    'bug': const Color(0xFFA6B91A),
    'rock': const Color(0xFFB6A136),
    'ghost': const Color(0xFF6F5797),
    'dragon': const Color(0xFF986EFA),
    'dark': const Color(0xFF54534F),
    'steel': const Color(0xFFB7B7CE),
    'fairy': const Color(0xFFD685AD),
  };

  static final Map<String, Color> pokemonColors = {
    'red': const Color(0xFFEE6343),
    'blue': const Color(0xFF6671C7),
    'yellow': const Color(0xFFD8CA6F),
    'green': const Color(0xFF40B868),
    'black': const Color(0xFF4A4A4A),
    'brown': const Color(0xFFA1871F),
    'purple': const Color(0xFF5F325F),
    'gray': const Color(0xFFA0A0A0),
    'white': const Color(0xFFBDBDBD),
    'pink': const Color(0xFFD685AD),
  };
}
