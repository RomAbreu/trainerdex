import 'package:flutter/material.dart';
import 'package:trainerdex/constants/app_values.dart';
import 'package:trainerdex/utils.dart';
import 'package:trainerdex/views/pokemon_details/widgets/background_sliver_app_bar.dart';

class PokemonDetailsView extends StatefulWidget {
  final int pokemonId;
  final String pokemonName;
  final String pokemonGenus;
  final List<String> pokemonTypes;
  final Color pokemonColor;
  final String imageUrl;

  const PokemonDetailsView(
      {super.key,
      required this.pokemonId,
      required this.pokemonName,
      required this.pokemonGenus,
      required this.pokemonTypes,
      required this.pokemonColor,
      required this.imageUrl});

  @override
  State<PokemonDetailsView> createState() => _PokemonDetailsViewState();
}

class _PokemonDetailsViewState extends State<PokemonDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Utils.lightenColor(widget.pokemonColor),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 500.0,
            title: Text(
              widget.pokemonName,
              style: TextStyle(
                  color: Utils.lightenColor(
                      widget.pokemonColor, AppValues.kTextLightenFactor)),
            ),
            pinned: true,
            backgroundColor: Utils.lightenColor(
                widget.pokemonColor, AppValues.kAppBarBackgroundLightenFactor),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: BackgroundSliverAppBar(
                pokemonId: widget.pokemonId,
                pokemonName: widget.pokemonName,
                pokemonGenus: widget.pokemonGenus,
                pokemonTypes: widget.pokemonTypes,
                imageUrl: widget.imageUrl,
                pokemonColor: widget.pokemonColor,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 400,
                  color: Utils.lightenColor(widget.pokemonColor, 0.5),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Utils.lightenColor(widget.pokemonColor, 0.5),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Utils.lightenColor(widget.pokemonColor, 0.5),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Utils.lightenColor(widget.pokemonColor, 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
