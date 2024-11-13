import 'dart:ui';
import 'package:trainerdex/constants/app_theme.dart';

class Pokemon {
  final int id;
  final int speciesId;
  final String name;
  final String imageUrl;
  final String genus;
  final List<String> types;
  final Color color;
  final List<String>? formNames;

  Pokemon({
    required this.id,
    required this.speciesId,
    required this.name,
    required this.imageUrl,
    required this.genus,
    required this.types,
    required this.color,
    this.formNames,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      speciesId: json['pokemon_species_id'],
      name: json['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesnames'][0]
          ['name'],
      imageUrl: json['pokemon_v2_pokemonsprites'][0]['sprites'],
      genus: json['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesnames']
          [0]['genus'],
      types: (json['pokemon_v2_pokemontypes'] as List)
          .map((type) => type['pokemon_v2_type']['name'] as String)
          .toList(),
      formNames: (json['pokemon_v2_pokemonforms'][0]
                  ['pokemon_v2_pokemonformnames']
              .isEmpty)
          ? []
          : (json['pokemon_v2_pokemonforms'][0]['pokemon_v2_pokemonformnames']
                  as List)
              .map((form) => form['name'] as String)
              .toList(),
      color: AppTheme.pokemonColors[json['pokemon_v2_pokemonspecy']
          ['pokemon_v2_pokemoncolor']['name']]!,
    );
  }
}
