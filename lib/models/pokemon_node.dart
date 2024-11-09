import 'package:trainerdex/models/pokemon.dart';

class PokemonNode {
  final Pokemon pokemon;
  List<PokemonNode>? evolutions;
  final List<int> evolutionIds;

  PokemonNode(
      {required this.pokemon,
      required this.evolutions,
      required this.evolutionIds});
}
