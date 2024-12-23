import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/models/generation_info.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/shared_preferences_helper.dart';
import 'package:trainerdex/models/pokemon_ability.dart';

class PokemonRepository {
  static Future<List<Pokemon>> getPokemonsWithOffset(
      GraphQLClient client, bool fetchFavorites, int offset,
      [List<String>? typeFilter,
      List<int>? abilitiesFilter,
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

    final filters = _prepareFilters(
      fetchFavorites,
      SharedPreferencesHelper.instance.getFavoritesPokemons(),
      typeFilter,
      abilitiesFilter,
      generationFilter,
      searchQuery,
    );
    final QueryResult result = await client.query(QueryOptions(
      document: gql(query),
      fetchPolicy: FetchPolicy.noCache,
      variables: {
        'offset': offset,
        'where': filters,
      },
    ));

    final List<dynamic> data = result.data?['pokemon_v2_pokemon'] ?? [];
    return data.map((json) => Pokemon.fromJson(json)).toList();
  }

  static Future<List<GenerationInfo>> getGenerations(
    GraphQLClient client,
  ) async {
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

    final QueryResult result = await client.query(QueryOptions(
      document: gql(query),
    ));
    final List<dynamic> data = result.data?['pokemon_v2_generation'] ?? [];
    return data.map((json) => GenerationInfo.fromJson(json)).toList();
  }

  static Future<int> countPokemons(
    GraphQLClient client,
    bool fetchFavorites, [
    List<String>? typeFilter,
    List<int>? abilitiesFilter,
    int? generationFilter,
    String? searchQuery,
  ]) async {
    const String query = """
      query getTotalPokemons(\$where: pokemon_v2_pokemon_bool_exp) {
        pokemon_v2_pokemon_aggregate(where: \$where) {
          aggregate {
            count
          }
        }
      }
    """;

    final filters = _prepareFilters(
      fetchFavorites,
      SharedPreferencesHelper.instance.getFavoritesPokemons(),
      typeFilter,
      abilitiesFilter,
      generationFilter,
      searchQuery,
    );

    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.noCache,
        variables: {'where': filters},
      ),
    );
    return result.data?['pokemon_v2_pokemon_aggregate']['aggregate']['count'];
  }

  static Future<List<PokemonAbility>> getAllAbilitiesWithOffset(
      GraphQLClient client, int currentOffset, String searchQuery) async {
    const String query = """
      query obtainAllAbilities(\$offset: Int!, \$where: pokemon_v2_abilityname_bool_exp) {
        pokemon_v2_abilityname(where: \$where, offset: \$offset, limit: 60) {
          ability_id
          name
        }
      }

    """;

    final QueryResult result =
        await client.query(QueryOptions(document: gql(query), variables: {
      'offset': currentOffset,
      'where': {
        'pokemon_v2_language': const {
          'name': {'_eq': "en"}
        },
        if (searchQuery.isNotEmpty) 'name': {'_ilike': '%$searchQuery%'}
      },
    }));
    final List<dynamic> data = result.data?['pokemon_v2_abilityname'] ?? [];
    return data.map((json) => PokemonAbility.fromJson(json)).toList();
  }

  static Future<int> countAbilities(
      GraphQLClient client, String searchQuery) async {
    const String query = """
      query getTotalAbilities(\$where: pokemon_v2_abilityname_bool_exp) {
        pokemon_v2_abilityname_aggregate(distinct_on: ability_id, where: \$where) {
          aggregate {
            count
          }
        }
      }
    """;

    final QueryResult result = await client.query(QueryOptions(
      document: gql(query),
      variables: {
        'where': {
          if (searchQuery.isNotEmpty) 'name': {'_ilike': '%$searchQuery%'}
        }
      },
    ));
    return result.data?['pokemon_v2_abilityname_aggregate']['aggregate']
        ['count'];
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
        return '{pokemon_v2_pokemontypes_aggregate: {min: {type_id: ${orderOptions[selectedOrderOption ?? 0]}}}}';
      case 3:
        return '{pokemon_v2_pokemonabilities_aggregate: {min: {ability_id: ${orderOptions[selectedOrderOption ?? 0]}}}}';
      default:
        return '{pokemon_species_id: ${orderOptions[selectedOrderOption ?? 0]}}';
    }
  }

  static Map<String, dynamic> _prepareFilters(
      bool fetchFavorites, List<String> favoritePokemons,
      [List<String>? typeFilter,
      List<int>? abilitiesFilter,
      int? generationFilter,
      String? searchQuery]) {
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

    if (abilitiesFilter != null && abilitiesFilter.isNotEmpty) {
      filters['pokemon_v2_pokemonabilities'] = {
        'pokemon_v2_ability': {
          'id': {'_in': abilitiesFilter}
        }
      };
    }

    if (fetchFavorites) {
      filters['id'] = {'_in': favoritePokemons};
    }

    return filters;
  }
}
