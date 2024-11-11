import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/repositories/pokemon_repository.dart';
import 'package:trainerdex/views/home/widgets/home_appbar.dart';
import 'package:trainerdex/views/home/widgets/home_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentOffset = 0;
  final List<Pokemon> _pokemons = [];
  final List<String> _typeFilterArgs = [];

  // Methods for updating ListView
  void updateOffset() {
    setState(() {
      _currentOffset += 12;
    });
  }

  void refreshList() {
    setState(() {
      _pokemons.clear();
      _currentOffset = 0;
    });
  }

  Future<void> fetchPokemons() async {
    final List<Pokemon> pokemons =
        await PokemonRepository.getPokemonsWithOffset(
      GraphQLProvider.of(context).value,
      _currentOffset,
      _typeFilterArgs,
    );

    setState(() {
      _pokemons.addAll(pokemons);
    });
  }
  // Methods for updating ListView

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        fetchPokemons: fetchPokemons,
        refreshList: refreshList,
        updateOffset: updateOffset,
        typeFilterArgs: _typeFilterArgs,
      ),
      body: HomeListview(
        pokemons: _pokemons,
        fetchPokemons: fetchPokemons,
        refreshList: refreshList,
        updateOffset: updateOffset,
      ),
    );
  }
}
