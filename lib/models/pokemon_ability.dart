class PokemonAbility {
  final int? id;
  final String name;
  final bool? isHidden;
  final String? flavorText;
  final String? effect;

  PokemonAbility({
    required this.name,
    this.isHidden,
    this.flavorText,
    this.effect,
    this.id,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      id: json['ability_id'],
      name: json['name'],
    );
  }
}
