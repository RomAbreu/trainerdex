import 'package:flutter/material.dart';
import 'package:trainerdex/constants/app_values.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/utils.dart';
import 'package:trainerdex/widgets/pokemon_type_container.dart';

class BackgroundSliverAppBar extends StatelessWidget {
  final Pokemon pokemon;
  final int option;

  const BackgroundSliverAppBar(
      {super.key, required this.pokemon, this.option = 0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: '${pokemon.id}-$option',
            child: Image.network(pokemon.imageUrl,
                height: AppValues.kPokemonDetailsImageHeight),
          ),
          Text(
            pokemon.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 50,
                color: Utils.lightenColor(pokemon.color),
                fontWeight: FontWeight.bold),
          ),
          Text(
            pokemon.genus,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Utils.lightenColor(pokemon.color),
                fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 15),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pokemon.types
                  .map((t) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: PokemonTypeContainer(
                            type: t, pokemonColor: pokemon.color),
                      ))
                  .toList())
        ],
      ),
    );
  }
}
