import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trainerdex/constants/pokemon_types_util.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/utils.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageSide extends StatelessWidget {
  final Pokemon pokemon;
  final Color color;
  const ImageSide({
    super.key,
    required this.pokemon,
    required this.color,
  });

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
          child: Hero(
            tag: '${pokemon.id}-0',
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: pokemon.imageUrl,
              width: 95,
              fadeInDuration: const Duration(milliseconds: 150),
            ),
          ),
        ),
      ),
    );
  }
}

class InformationSide extends StatefulWidget {
  final Pokemon pokemon;
  const InformationSide({super.key, required this.pokemon});

  @override
  State<InformationSide> createState() => _InformationSideState();
}

class _InformationSideState extends State<InformationSide> {
  bool _isFavorite = false;

  void _loadFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.getBool(widget.pokemon.id.toString()) ?? false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFavorite();
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
                  Utils.formatPokemonName(widget.pokemon),
                  style: _nameStyle,
                  maxLines: 2,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(children: [
                for (final type in widget.pokemon.types)
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
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    setState(() {
                      _isFavorite = !_isFavorite;
                      if (_isFavorite) {
                        prefs.setBool(widget.pokemon.id.toString(), true);
                      } else {
                        prefs.remove(widget.pokemon.id.toString());
                      }
                    });
                  },
                  icon: Icon(_favoriteIcon),
                  padding: const EdgeInsets.all(0),
                  constraints: const BoxConstraints(),
                  style: IconButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Text('#${widget.pokemon.speciesId}', style: _idStyle),
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

  IconData get _favoriteIcon =>
      _isFavorite ? Icons.favorite : Icons.favorite_border;
}
