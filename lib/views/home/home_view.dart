import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/repositories/pokemon_general_repository.dart';
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
  int _selectedGeneration = 0;
  int _totalPokemonsCounter = 0;
  bool _showFavorites = false;

  // Methods for updating ListView
  void updateOffset() {
    setState(() {
      _currentOffset += 25;
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
      _showFavorites,
      _currentOffset,
      _typeFilterArgs,
      _selectedGeneration,
    );

    setState(() {
      _pokemons.addAll(pokemons);
    });
  }

  void setGeneration(int value) {
    setState(() {
      _selectedGeneration = value;
    });
  }

  int getGeneration() {
    return _selectedGeneration;
  }

  Future<void> countPokemons() async {
    final counter = await PokemonRepository.countPokemons(
      GraphQLProvider.of(context).value,
      _showFavorites,
      _typeFilterArgs,
      _selectedGeneration,
    );

    setState(() {
      _totalPokemonsCounter = counter;
    });
  }
  // Methods for updating ListView

  void updateShowFavorites() {
    setState(() {
      _showFavorites = !_showFavorites;
    });
  }

  void _removePokemonWhenDisplayingFavorites(int index) {
    if (!_showFavorites) return;

    setState(() {
      _pokemons.removeAt(index);
      _totalPokemonsCounter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        fetchPokemons: fetchPokemons,
        refreshList: refreshList,
        updateOffset: updateOffset,
        typeFilterArgs: _typeFilterArgs,
        selectedGeneration: getGeneration,
        onChangedGeneration: setGeneration,
        pokemonsCounter: _totalPokemonsCounter,
        refreshCounter: countPokemons,
        updateShowFavorites: updateShowFavorites,
        showFavorites: _showFavorites,
      ),
      body: HomeListview(
        pokemons: _pokemons,
        fetchPokemons: fetchPokemons,
        refreshList: refreshList,
        updateOffset: updateOffset,
        pokemonsCounter: _totalPokemonsCounter,
        refreshCounter: countPokemons,
        showFavorites: _showFavorites,
        removePokemonWhenDisplayingFavorites:
            _removePokemonWhenDisplayingFavorites,
      ),
    );
  }
}
