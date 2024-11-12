import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/models/pokemon.dart';

class PokemonRepository {
  static Future<List<Pokemon>> getPokemonsWithOffset(
      GraphQLClient client, int offset,
      [List<String>? typeFilter, List<String>? generationFilter]) async {
    const String query = """
      query samplePokeAPIquery(\$offset: Int!, \$where: pokemon_v2_pokemon_bool_exp) {
        pokemon_v2_pokemon(offset: \$offset, limit: 12, order_by: {pokemon_species_id: asc}, where: \$where) {
          id
          pokemon_v2_pokemonsprites {
            sprites(path: "other.official-artwork.front_default")
          }
          pokemon_v2_pokemonspecy {
            pokemon_v2_pokemonspeciesnames(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
              name
              genus
            }
            pokemon_v2_pokemoncolor {
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

    final filters = _prepareFilters(typeFilter, generationFilter);

    final QueryResult result =
        await client.query(QueryOptions(document: gql(query), variables: {
      'offset': offset,
      'where': filters.isEmpty ? {} : filters,
    }));

    final List<dynamic> data = result.data?['pokemon_v2_pokemon'] ?? [];
    return data.map((json) => Pokemon.fromJson(json)).toList();
  }

  static Map<String, dynamic> _prepareFilters(
      [List<String>? typeFilter, List<String>? generationFilter]) {
    final filters = <String, dynamic>{};

    if (typeFilter != null && typeFilter.isNotEmpty) {
      filters['pokemon_v2_pokemontypes'] = {
        'pokemon_v2_type': {
          'name': {'_in': typeFilter}
        }
      };
    }

    return filters;
  }
}
