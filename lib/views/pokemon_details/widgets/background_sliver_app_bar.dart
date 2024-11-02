import 'package:flutter/material.dart';
import 'package:trainerdex/constants/app_values.dart';
import 'package:trainerdex/utils.dart';
import 'package:trainerdex/widgets/pokemon_type_container.dart';

class BackgroundSliverAppBar extends StatelessWidget {
  final int pokemonId;
  final String pokemonName;
  final String pokemonGenus;
  final List<String> pokemonTypes;
  final String imageUrl;
  final Color pokemonColor;

  const BackgroundSliverAppBar(
      {super.key,
      required this.pokemonId,
      required this.pokemonName,
      required this.pokemonGenus,
      required this.pokemonTypes,
      required this.imageUrl,
      required this.pokemonColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(imageUrl, height: AppValues.kPokemonDetailsImageHeight),
          Text(
            pokemonName,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 50,
                color: Utils.lightenColor(pokemonColor),
                fontWeight: FontWeight.bold),
          ),
          Text(
            pokemonGenus,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Utils.lightenColor(pokemonColor),
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemonTypes
                  .map((t) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: PokemonTypeContainer(
                            type: t, pokemonColor: pokemonColor),
                      ))
                  .toList())
        ],
      ),
    );
  }
}
