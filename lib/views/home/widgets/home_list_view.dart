import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/views/home/widgets/home_list_item.dart';
import 'package:trainerdex/views/pokemon_details/pokemon_details_view.dart';

class HomeListview extends StatefulWidget {
  final List<Pokemon> pokemons;
  final VoidCallback refreshList;
  final VoidCallback updateOffset;
  final Future<void> Function() fetchPokemons;

  const HomeListview({
    super.key,
    required this.pokemons,
    required this.fetchPokemons,
    required this.refreshList,
    required this.updateOffset,
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
          return ListItem(pokemon: widget.pokemons[index]);
        }
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class ListItem extends StatelessWidget {
  final Pokemon pokemon;
  const ListItem({super.key, required this.pokemon});

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
                  builder: (context) => PokemonDetailsView(pokemon: pokemon),
                ),
              );
            },
            child: Row(
              children: [
                ImageSide(pokemon: pokemon, color: mainColor.withOpacity(0.7)),
                const SizedBox(width: 10),
                InformationSide(pokemon: pokemon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
