import 'package:flutter/material.dart';

class Utils {
  static Color lightenColor(Color color, [double amount = 0.85]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    return Color.lerp(color, Colors.white, amount)!;
  }

  static Color darkenColor(Color color, [double amount = 0.85]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    return Color.lerp(color, Colors.black, amount)!;
  }

  static String cleanFlavorText(String flavorText) {
    return flavorText.replaceAll('\n', ' ').replaceAll('\f', ' ');
  }

  static double convertDecimetersToMeters(int decimeters) {
    return decimeters / 10.0;
  }

  static double convertHectogramsToKilograms(int hectograms) {
    return hectograms / 10.0;
  }
}
