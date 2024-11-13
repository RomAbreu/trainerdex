import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trainerdex/constants/app_values.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/utils.dart';
import 'package:trainerdex/widgets/pokemon_type_container.dart';

class BackgroundSliverAppBar extends StatelessWidget {
  final Pokemon pokemon;
  final int option;

  const BackgroundSliverAppBar({
    super.key,
    required this.pokemon,
    this.option = 0,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Hero(
            tag: '${pokemon.id}-$option',
            child: Image.network(
              pokemon.imageUrl,
              height: AppValues.kPokemonDetailsImageHeight,
            ),
          ),
          Container(
            constraints: BoxConstraints(maxWidth: size.width, maxHeight: 120),
            child: AutoSizeText(
              Utils.formatPokemonName(pokemon),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                color: Utils.lightenColor(pokemon.color),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            pokemon.genus,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Utils.lightenColor(pokemon.color),
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pokemon.types
                .map(
                  (t) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: PokemonTypeContainer(
                      type: t,
                      pokemonColor: pokemon.color,
                    ),
                  ),
                )
                .toList(),
          )
        ],
      ),
    );
  }
}
