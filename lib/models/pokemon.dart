import 'dart:ui';

class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String genus;
  final List<String> types;
  final Color color;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.genus,
    required this.types,
    required this.color,
  });
}
