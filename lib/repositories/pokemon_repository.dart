import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/entities/pokemon.dart';

class PokemonRepository {
  static Future<List<Pokemon>> getAllPokemons(GraphQLClient client) async {
    const String query = """
      query samplePokeAPIquery {
        pokemon_v2_pokemon(limit: 25) {
          id
          pokemon_v2_pokemonsprites {
            sprites(path: "other.official-artwork.front_default")
          }
          pokemon_v2_pokemonspecy {
            pokemon_v2_pokemonspeciesnames(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
              name
            }
          }
          pokemon_v2_pokemontypes {
            pokemon_v2_type {
              name
            }
          }
        }
      }
    """;

    final QueryResult result =
        await client.query(QueryOptions(document: gql(query)));

    final List<dynamic> data = result.data?['pokemon_v2_pokemon'] ?? [];
    return data.map((json) => Pokemon.fromJson(json)).toList();
  }
}
