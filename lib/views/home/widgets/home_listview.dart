import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/constants/pokemon_types_util.dart';
import 'package:trainerdex/entities/pokemon.dart';
import 'package:trainerdex/repositories/pokemon_repository.dart';
import 'package:trainerdex/views/home/widgets/home_list_item.dart';

class HomeListview extends StatefulWidget {
  const HomeListview({super.key});

  @override
  State<HomeListview> createState() => _HomeListviewState();
}

class _HomeListviewState extends State<HomeListview> {
  int _currentOffset = 0;
  late ScrollController controller;
  late GraphQLClient client;
  final List<Pokemon> _pokemons = [];

  @override
  void initState() {
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    client = GraphQLProvider.of(context).value;
    _fetchPokemons();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      setState(() {
        _currentOffset += 12;
      });
      _fetchPokemons();
    }
  }

  Future<void> _fetchPokemons() async {
    final List<Pokemon> pokemons =
        await PokemonRepository.getPokemonsWithOffset(client, _currentOffset);
    setState(() {
      _pokemons.addAll(pokemons);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      itemCount: _pokemons.length + 1,
      itemBuilder: (context, index) {
        if (index < _pokemons.length) {
          return ListItem(pokemon: _pokemons[index]);
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
    final Color mainColor = typeColors[pokemon.types.first]!;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 2.0),
      child: SizedBox(
        height: 114,
        child: Card.filled(
          color: Color.alphaBlend(Colors.white.withOpacity(0.5), mainColor),
          child: Row(
            children: [
              ImageSide(pokemon: pokemon, color: mainColor.withOpacity(0.7)),
              const SizedBox(width: 10),
              InformationSide(pokemon: pokemon),
            ],
          ),
        ),
      ),
    );
  }
}
