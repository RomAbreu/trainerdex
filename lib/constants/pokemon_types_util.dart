import 'package:flutter/material.dart';

// CONSTANTS
const Map<String, Color> typeColors = {
  'normal': Color(0xFF929da3),
  'fighting': Color(0xFFce416b),
  'flying': Color(0xFF8fa9de),
  'rock': Color(0xFFc5b78c),
  'ground': Color(0xFFd97845),
  'poison': Color(0xFFaa6bc8),
  'bug': Color(0xFF91c12f),
  'ghost': Color(0xFF5269ad),
  'steel': Color(0xFF5a8ea2),
  'fire': Color(0xFFff9d55),
  'water': Color(0xFF5090d6),
  'grass': Color(0xFF63bc5a),
  'ice': Color(0xFF73cec0),
  'psychic': Color(0xFFfa7179),
  'electric': Color(0xFFf4d23c),
  'dragon': Color(0xFF0b6dc3),
  'dark': Color(0xFF5a5465),
  'fairy': Color(0xFFec8fe6),
  '???': Color(0xFF68a090),
};

// WIDGETS
class TypeChip extends StatelessWidget {
  final String type;
  final double fontSize;
  const TypeChip({super.key, required this.type, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 3.0),
      child: Chip(
        avatar: Image.asset('assets/$type.png'),
        label: Text('${type[0].toUpperCase()}${type.substring(1)}'),
        labelStyle: _typeStyle,
        backgroundColor: typeColors[type] ?? typeColors['???'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }

  TextStyle get _typeStyle => TextStyle(
        fontSize: fontSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      );
}
