import 'package:flutter/material.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/models/pokemon_node.dart';
import 'package:trainerdex/utils.dart';
import 'package:trainerdex/views/pokemon_details/pokemon_details_view.dart';

class PokemonEvolutionChain extends StatelessWidget {
  final List<Pokemon> pokemons;
  final PokemonNode pokemonNode;
  final int pokemonId;
  final int option;

  const PokemonEvolutionChain({
    super.key,
    required this.pokemons,
    required this.pokemonNode,
    required this.pokemonId,
    this.option = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(child: buildPokemonTree(context, pokemonNode));
  }

  Widget buildPokemonTree(BuildContext context, PokemonNode node,
      [bool isFirst = true]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!isFirst) const Icon(Icons.arrow_forward_rounded),
        buildPokemonNode(context, node, isFirst),
        if (node.evolutions != null)
          Column(
            children: [
              for (var evolution in node.evolutions!) ...[
                buildPokemonTree(context, evolution, false),
              ],
            ],
          )
      ],
    );
  }

  Widget buildPokemonNode(BuildContext context, PokemonNode node,
      [bool isFirst = true]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (pokemonId == node.pokemon.id) return;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PokemonDetailsView(
                    pokemons: pokemons,
                    pokemon: node.pokemon,
                    option: option + 1,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: node.pokemon.color, width: 2.5),
                borderRadius: BorderRadius.circular(8.0),
                color: Utils.lightenColor(node.pokemon.color, 0.9),
              ),
              child: Column(
                children: [
                  Hero(
                    tag: '${node.pokemon.id}-${option + 1}',
                    child: Image.network(
                      node.pokemon.imageUrl,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  Text(node.pokemon.name,
                      style: TextStyle(
                          fontSize: node.pokemon.name.length < 10 ? 12 : 8,
                          color: node.pokemon.color,
                          fontWeight: FontWeight.bold)),
                  Column(
                    children: [
                      for (final type in node.pokemon.types) ...[
                        Text(
                          type.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ]
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
