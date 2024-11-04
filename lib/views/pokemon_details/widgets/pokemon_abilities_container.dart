import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trainerdex/models/pokemon_ability.dart';
import 'package:trainerdex/utils.dart';

class PokemonAbilitiesContainer extends StatelessWidget {
  final Color pokemonColor;
  final List<PokemonAbility> abilities;
  const PokemonAbilitiesContainer({
    super.key,
    required this.pokemonColor,
    required this.abilities,
  });

  @override
  Widget build(BuildContext context) {
    List<PokemonAbility> hiddenAbilities =
        abilities.where((ability) => ability.isHidden).toList();
    List<PokemonAbility> normalAbilities =
        abilities.where((ability) => !ability.isHidden).toList();

    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < normalAbilities.length; i++) ...[
              Expanded(child: _displayAbility(normalAbilities[i])),
              if (i < normalAbilities.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
        if (hiddenAbilities.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              for (var i = 0; i < hiddenAbilities.length; i++) ...[
                Expanded(child: _displayAbility(hiddenAbilities[i])),
                if (i < hiddenAbilities.length - 1) const SizedBox(width: 8),
              ],
            ],
          )
        ]
      ],
    );
  }

  Widget _displayAbility(PokemonAbility ability) {
    return Container(
      decoration: BoxDecoration(
        color: Utils.lightenColor(pokemonColor),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: pokemonColor),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Stack(alignment: AlignmentDirectional.centerStart, children: [
              Icon(Icons.info_outline_rounded, color: pokemonColor, size: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: ability.name,
                        style: TextStyle(
                            fontFamily: GoogleFonts.manrope().fontFamily,
                            color: pokemonColor,
                            fontSize: ability.name.length > 12 ? 12 : 16,
                            fontWeight: FontWeight.bold),
                      ),
                      if (ability.isHidden)
                        TextSpan(
                          text: ' (Hidden)',
                          style: TextStyle(
                              fontFamily: GoogleFonts.manrope().fontFamily,
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                    ]),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
