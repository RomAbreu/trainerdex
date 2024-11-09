import 'package:flutter/material.dart';
import 'package:trainerdex/utils.dart';

class PokemonTypeContainer extends StatelessWidget {
  final String type;
  final Color pokemonColor;
  const PokemonTypeContainer({
    super.key,
    required this.type,
    required this.pokemonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Utils.lightenColor(pokemonColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(type.toUpperCase(),
            style: TextStyle(color: Utils.lightenColor(pokemonColor)),
            textAlign: TextAlign.center),
      ),
    );
  }
}
