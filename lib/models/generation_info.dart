class GenerationInfo {
  final int id;
  final String name;

  GenerationInfo({
    required this.id,
    required this.name,
  });

  factory GenerationInfo.fromJson(Map<String, dynamic> json) {
    return GenerationInfo(
      id: json['id'],
      name: json['pokemon_v2_generationnames'][0]['name'],
    );
  }
}
