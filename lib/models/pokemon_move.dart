class PokemonMove {
  final String name;
  final String type;
  final int level;
  final int? machineNumber;
  final int? power;
  final int pp;
  final int? accuracy;
  final String method;
  final String damageClass;

  PokemonMove({
    required this.name,
    required this.type,
    required this.level,
    this.machineNumber,
    this.power,
    required this.pp,
    this.accuracy,
    required this.method,
    required this.damageClass,
  });
}
