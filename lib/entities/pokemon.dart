class Pokemon {
  final int id;
  final String name;
  final String spriteUrl;
  final List<String> types;
  final List<String> formNames;

  Pokemon(
      {required this.id,
      required this.name,
      required this.spriteUrl,
      required this.types,
      required this.formNames});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['pokemon_species_id'],
      name: json['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesnames'][0]
          ['name'],
      spriteUrl: json['pokemon_v2_pokemonsprites'][0]['sprites'],
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
    );
  }
}
