import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/entities/pokemon.dart';
import 'package:trainerdex/repositories/pokemon_repository.dart';

class HomeListview extends StatelessWidget {
  const HomeListview({super.key});

  Future<List<Pokemon>> _fetchPokemons(GraphQLClient client) {
    return PokemonRepository.getAllPokemons(client);
  }

  @override
  Widget build(BuildContext context) {
    final GraphQLClient client = GraphQLProvider.of(context).value;

    return FutureBuilder(
        future: _fetchPokemons(client),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'An error occurred while fetching the data: ${snapshot.error}'));
          } else {
            final List<Pokemon> pokemons = snapshot.data!;
            return _PokemonList(pokemons: pokemons);
          }
        });
  }
}

class _PokemonList extends StatelessWidget {
  final List<Pokemon> pokemons;

  const _PokemonList({required this.pokemons});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          final pokemon = pokemons[index];
          return Card.filled(
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  Image.network(pokemon.spriteUrl),
                  Column(
                    children: [
                      Text(pokemon.name),
                      Text(pokemon.types.join(', ')),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
