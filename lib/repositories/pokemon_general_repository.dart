import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/models/generation_info.dart';
import 'package:trainerdex/models/pokemon.dart';

class PokemonRepository {
  static Future<List<Pokemon>> getPokemonsWithOffset(
      GraphQLClient client, int offset,
      [List<String>? typeFilter,
      int? generationFilter,
      String? searchQuery,
      int? selectedOrderOption,
      int? selectedSortOption]) async {
    String sort = _prepareSorting(selectedSortOption, selectedOrderOption);

    String query = """
      query samplePokeAPIquery(\$offset: Int!, \$where: pokemon_v2_pokemon_bool_exp) {
        pokemon_v2_pokemon(offset: \$offset, limit: 25, order_by: $sort, where: \$where) {
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

    final filters = _prepareFilters(typeFilter, generationFilter, searchQuery);
    final QueryResult result = await client.query(QueryOptions(
      document: gql(query),
      variables: {
        'offset': offset,
        'where': filters,
      },
    ));

    final List<dynamic> data = result.data?['pokemon_v2_pokemon'] ?? [];
    return data.map((json) => Pokemon.fromJson(json)).toList();
  }

  static Future<List<GenerationInfo>> getGenerations(
      GraphQLClient client) async {
    const String query = """
      query obtainAllGenerations {
        pokemon_v2_generation {
          id
          pokemon_v2_generationnames(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
            name
          }
        }
      }
      """;

    final QueryResult result =
        await client.query(QueryOptions(document: gql(query)));
    final List<dynamic> data = result.data?['pokemon_v2_generation'] ?? [];
    return data.map((json) => GenerationInfo.fromJson(json)).toList();
  }

  static Future<int> countPokemons(GraphQLClient client,
      [List<String>? typeFilter,
      int? generationFilter,
      String? searchQuery]) async {
    const String query = """
      query getTotalPokemons(\$where: pokemon_v2_pokemon_bool_exp) {
        pokemon_v2_pokemon_aggregate(where: \$where) {
          aggregate {
            count
          }
        }
      }
    """;

    final filters = _prepareFilters(typeFilter, generationFilter, searchQuery);

    final QueryResult result = await client.query(
      QueryOptions(document: gql(query), variables: {'where': filters}),
    );
    return result.data?['pokemon_v2_pokemon_aggregate']['aggregate']['count'];
  }

  // Methods without GraphQL
  static String _prepareSorting(
      int? selectedSortOption, int? selectedOrderOption) {
    final List<String> orderOptions = ['asc', 'desc'];

    switch (selectedSortOption) {
      case 0:
        return '{pokemon_species_id: ${orderOptions[selectedOrderOption ?? 0]}}';
      case 1:
        return '{name: ${orderOptions[selectedOrderOption ?? 0]}}';
      case 2:
        return '{pokemon_v2_pokemontypes_aggregate: {min: {type_id:${orderOptions[selectedOrderOption ?? 0]}}}}';
      default:
        return '{pokemon_species_id: ${orderOptions[selectedOrderOption ?? 0]}}';
    }
  }

  static Map<String, dynamic> _prepareFilters(
      [List<String>? typeFilter, int? generationFilter, String? searchQuery]) {
    final filters = <String, dynamic>{};
    filters['pokemon_v2_pokemonforms'] = {
      'is_default': {'_eq': true}
    };

    if (typeFilter != null && typeFilter.isNotEmpty) {
      filters['pokemon_v2_pokemontypes'] = {
        'pokemon_v2_type': {
          'name': {'_in': typeFilter}
        }
      };
    }

    if (generationFilter != null && generationFilter > 0) {
      filters['pokemon_v2_pokemonspecy'] = {
        'generation_id': {'_eq': generationFilter}
      };
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      int? idConvertion = int.tryParse(searchQuery);

      (idConvertion != null)
          ? filters['pokemon_species_id'] = {'_eq': idConvertion}
          : filters['pokemon_v2_pokemonspecy'] = {
              'name': {'_ilike': '%$searchQuery%'}
            };
    }

    return filters;
  }
}
