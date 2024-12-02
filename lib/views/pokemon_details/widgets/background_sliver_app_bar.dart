import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:trainerdex/constants/app_values.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/utils.dart';
import 'package:trainerdex/widgets/pokemon_type_container.dart';

class BackgroundSliverAppBar extends StatelessWidget {
  final Pokemon pokemon;
  final int evolutionHeroTag;
  final bool isForScreenShot;
  final int nextPokemonHeroTag;

  const BackgroundSliverAppBar({
    super.key,
    required this.pokemon,
    this.evolutionHeroTag = 0,
    this.isForScreenShot = false,
    this.nextPokemonHeroTag = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Utils.lightenColor(
          pokemon.color, AppValues.kAppBarBackgroundLightenFactor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          Hero(
            tag: '${pokemon.id}-$evolutionHeroTag-$nextPokemonHeroTag',
            child: Image.network(
              pokemon.imageUrl,
              height: AppValues.kPokemonDetailsImageHeight,
            ),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: Text(
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
          ),
          if (isForScreenShot) const SizedBox(height: 80),
        ],
      ),
    );
  }
}
