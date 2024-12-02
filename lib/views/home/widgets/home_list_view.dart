import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/views/home/widgets/home_list_item.dart';
import 'package:trainerdex/views/pokemon_details/pokemon_details_view.dart';

class HomeListview extends StatefulWidget {
  final List<Pokemon> pokemons;
  final VoidCallback refreshList;
  final VoidCallback updateOffset;
  final int pokemonsCounter;
  final Future<void> Function() fetchPokemons;
  final Future<void> Function() refreshCounter;
  final bool showFavorites;
  final void Function(int) removePokemonWhenDisplayingFavorites;

  const HomeListview({
    super.key,
    required this.pokemons,
    required this.fetchPokemons,
    required this.refreshList,
    required this.updateOffset,
    required this.pokemonsCounter,
    required this.refreshCounter,
    required this.showFavorites,
    required this.removePokemonWhenDisplayingFavorites,
  });

  @override
  State<HomeListview> createState() => _HomeListviewState();
}

class _HomeListviewState extends State<HomeListview> {
  late ScrollController controller;
  late GraphQLClient client;

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.fetchPokemons();
    widget.refreshCounter();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      widget.updateOffset();
      widget.fetchPokemons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: widget.pokemons.length + 1,
      itemBuilder: (context, index) {
        if (index < widget.pokemons.length) {
          return ListItem(
            index: index,
            pokemons: widget.pokemons,
            pokemon: widget.pokemons[index],
            removePokemonWhenDisplayingFavorites:
                widget.removePokemonWhenDisplayingFavorites,
          );
        }
        if (widget.pokemonsCounter > widget.pokemons.length) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class ListItem extends StatelessWidget {
  final int index;
  final Pokemon pokemon;
  final List<Pokemon> pokemons;
  final void Function(int) removePokemonWhenDisplayingFavorites;

  const ListItem({
    super.key,
    required this.index,
    required this.pokemon,
    required this.pokemons,
    required this.removePokemonWhenDisplayingFavorites,
  });

  @override
  Widget build(BuildContext context) {
    final Color mainColor = pokemon.color;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
      child: SizedBox(
        height: 114,
        child: Card.filled(
          color: Color.alphaBlend(Colors.white.withOpacity(0.5), mainColor),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            splashColor: mainColor.withOpacity(0.3),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailsView(
                    pokemon: pokemon,
                    pokemons: pokemons,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                ImageSide(pokemon: pokemon, color: mainColor.withOpacity(0.7)),
                const SizedBox(width: 10),
                InformationSide(
                  index: index,
                  pokemon: pokemon,
                  removePokemonWhenDisplayingFavorites:
                      removePokemonWhenDisplayingFavorites,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
