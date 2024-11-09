import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/entities/pokemon.dart';

class PokemonRepository {
  static Future<List<Pokemon>> getPokemonsWithOffset(
      GraphQLClient client, int offset) async {
    const String query = """
      query samplePokeAPIquery(\$offset: Int!) {
        pokemon_v2_pokemon(offset: \$offset, limit: 12, order_by: {pokemon_species_id: asc}) {
          id
          pokemon_v2_pokemonsprites {
            sprites(path: "other.official-artwork.front_default")
          }
          pokemon_v2_pokemonspecy {
            pokemon_v2_pokemonspeciesnames(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
              name
            }
          }
          pokemon_v2_pokemonforms {
            pokemon_v2_pokemonformnames(where: {_or: [
              { pokemon_v2_language: { name: { _eq: "de" } } },
              { pokemon_v2_language: { name: { _eq: "en" } } }
              ]})
            {
              name
            }
          }
          pokemon_v2_pokemontypes {
            pokemon_v2_type {
              name
            }
          }
          pokemon_species_id
        }
      }
    """;

    final QueryResult result =
        await client.query(QueryOptions(document: gql(query), variables: {
      'offset': offset,
    }));

    final List<dynamic> data = result.data?['pokemon_v2_pokemon'] ?? [];
    return data.map((json) => Pokemon.fromJson(json)).toList();
  }
}
