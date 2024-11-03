class Pokemon {
  final int id;
  final String name;
  final String spriteUrl;
  final List<String> types;

  Pokemon(
      {required this.id,
      required this.name,
      required this.spriteUrl,
      required this.types});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesnames'][0]
          ['name'],
      spriteUrl: json['pokemon_v2_pokemonsprites'][0]['sprites'],
      types: (json['pokemon_v2_pokemontypes'] as List)
          .map((type) => type['pokemon_v2_type']['name'] as String)
          .toList(),
    );
  }
}
