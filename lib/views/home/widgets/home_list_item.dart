import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trainerdex/constants/pokemon_types_util.dart';
import 'package:trainerdex/entities/pokemon.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageSide extends StatelessWidget {
  final Pokemon pokemon;
  final Color color;
  const ImageSide({super.key, required this.pokemon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      margin: const EdgeInsets.all(0),
      color: color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
      ),
      child: SizedBox(
        width: 100,
        height: 108,
        child: Center(
          child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: pokemon.spriteUrl,
            width: 95,
            fadeInDuration: const Duration(milliseconds: 150),
          ),
        ),
      ),
    );
  }
}

class InformationSide extends StatelessWidget {
  const InformationSide({super.key, required this.pokemon});
  final Pokemon pokemon;

  String get _formmatedName {
    String name;

    if (pokemon.formNames.isEmpty) {
      return pokemon.name;
    }

    name = (pokemon.formNames.length > 1 && pokemon.formNames[1] != '')
        ? pokemon.formNames[1]
        : pokemon.formNames[0];

    if (!name.toLowerCase().contains(pokemon.name.toLowerCase())) {
      name = '${pokemon.name} $name';
    }

    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 173, maxHeight: 60),
                padding: const EdgeInsets.only(top: 10),
                child: AutoSizeText(
                  _formmatedName,
                  style: _nameStyle,
                  maxLines: 2,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(children: [
                for (final type in pokemon.types)
                  TypeChip(type: type, fontSize: 9.5)
              ]),
            ]),
        const Spacer(),
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Text('#${pokemon.id}', style: _idStyle),
              ),
            ]),
        const SizedBox(width: 9.5),
      ]),
    );
  }

  // Styles and shapes
  final TextStyle _nameStyle = const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54);

  final TextStyle _idStyle = const TextStyle(
      fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black45);
}
