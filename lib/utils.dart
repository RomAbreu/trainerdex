import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trainerdex/models/pokemon.dart';

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

  static deg2rad(double deg) {
    return deg / 180.0 * pi;
  }

  static capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  static String formatPokemonName(Pokemon pokemon) {
    String name;

    if (pokemon.formNames!.isEmpty) {
      return pokemon.name;
    }

    name = (pokemon.formNames!.length > 1 && pokemon.formNames![1] != '')
        ? pokemon.formNames![1]
        : pokemon.formNames![0];

    if (!name.toLowerCase().contains(pokemon.name.toLowerCase())) {
      name = '${pokemon.name} $name';
    }

    return name;
  }

  static Future<void> shareImage(Uint8List bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytesSync(bytes);

    await Share.shareXFiles(
      [XFile(image.path)],
      text: 'Check out this Pokémon!',
    );
  }
}
