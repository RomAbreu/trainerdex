import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/models/pokemon.dart';
import 'package:trainerdex/models/pokemon_ability.dart';
import 'package:trainerdex/models/pokemon_initial_data.dart';
import 'package:trainerdex/models/pokemon_move.dart';
import 'package:trainerdex/models/pokemon_node.dart';
import 'package:trainerdex/utils.dart';

class PokemonDetailsRepository {
  final GraphQLClient client;

  PokemonDetailsRepository({required this.client});

  Future<PokemonInitialData> fetchInitialData(int id) async {
    const query = '''
      query MyQuery(\$id: Int = 1) {
        pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
          name
          height
          weight
          base_experience
          pokemon_v2_pokemoncries {
            cries(path: "latest")
          }
          pokemon_v2_pokemonstats {
            base_stat
          }
          pokemon_v2_pokemonabilities {
            is_hidden
            pokemon_v2_ability {
              pokemon_v2_abilityflavortexts(where: {pokemon_v2_language: {name: {_eq: "en"}}, pokemon_v2_versiongroup: {name: {_eq: "emerald"}}}) {
                flavor_text
              }
              pokemon_v2_abilitynames(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
                name
              }
              pokemon_v2_abilityeffecttexts(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
                effect
              }
            }
          }
        }
      }
    ''';

    try {
      final result = await client.query(QueryOptions(
        document: gql(query),
        variables: {'id': id},
      ));

      final pokemonInitialData = PokemonInitialData(
        height: result.data!['pokemon_v2_pokemon'][0]['height'],
        weight: result.data!['pokemon_v2_pokemon'][0]['weight'],
        baseExperience: result.data!['pokemon_v2_pokemon'][0]
            ['base_experience'],
        cry: result.data!['pokemon_v2_pokemon'][0]['pokemon_v2_pokemoncries'][0]
            ['cries'],
        stats: _extractStats(
            result.data!['pokemon_v2_pokemon'][0]['pokemon_v2_pokemonstats']),
      );

      return pokemonInitialData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PokemonAbility>> fetchPokemonAbilities(
      int id, String versionGroup) async {
    const query = '''
      query MyQuery(\$id: Int = 1, \$versionGroup: String = "red-blue") {
        pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
          name
          pokemon_v2_pokemonabilities {
            is_hidden
            pokemon_v2_ability {
              pokemon_v2_abilityflavortexts(where: {pokemon_v2_language: {name: {_eq: "en"}}, pokemon_v2_versiongroup: {name: {_eq: \$versionGroup}}}) {
                flavor_text
              }
              pokemon_v2_abilitynames(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
                name
              }
              pokemon_v2_abilityeffecttexts(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
                effect
              }
            }
          }
        }
      }
    ''';

    try {
      final result = await client.query(QueryOptions(
        document: gql(query),
        variables: {'id': id, 'versionGroup': versionGroup},
      ));

      if (result.data == null) {
        return [];
      }

      final abilities = _extractAbilities(
          result.data!['pokemon_v2_pokemon'][0]['pokemon_v2_pokemonabilities']);

      return abilities;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PokemonMove>> fetchPokemonMoves(
      int id, String versionGroup) async {
    const query = '''
      query MyQuery(\$id: Int = 1, \$versionGroup: String = "red-blue") {
        pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
          name
          pokemon_v2_pokemonmoves(where: {pokemon_v2_movelearnmethod: {id: {_lte: 4}}, pokemon_v2_versiongroup: {name: {_eq: \$versionGroup}}}) {
            level
            pokemon_v2_move {
              accuracy
              power
              pp
              pokemon_v2_machines(where: {pokemon_v2_versiongroup: {name: {_eq: \$versionGroup}}}) {
                machine_number
              }
              pokemon_v2_type {
                name
              }
              pokemon_v2_movenames(where: {pokemon_v2_language: {name: {_eq: "en"}}}) {
                name
              }
              pokemon_v2_movedamageclass {
                name
              }
            }
            pokemon_v2_movelearnmethod {
              name
            }
          }
        }
      }
    ''';

    try {
      final result = await client.query(QueryOptions(
        document: gql(query),
        variables: {'id': id, 'versionGroup': versionGroup},
      ));

      if (result.data == null) {
        return [];
      }

      final moves = _extractMoves(
          result.data!['pokemon_v2_pokemon'][0]['pokemon_v2_pokemonmoves']);

      return moves;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> fetchPokemonFlavorText(int id, String versionGroup) async {
    const query = '''
      query MyQuery(\$id: Int = 1, \$versionGroup: String = "sword-shield") {
        pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
          name
          pokemon_v2_pokemonspecy {
            pokemon_v2_pokemonspeciesflavortexts(where: {pokemon_v2_language: {name: {_eq: "en"}}, pokemon_v2_version: {pokemon_v2_versiongroup: {name: {_eq: \$versionGroup}}}}, distinct_on: pokemon_species_id) {
              flavor_text
            }
          }
        }
      }
    ''';

    try {
      final result = await client.query(QueryOptions(
        document: gql(query),
        variables: {'id': id, 'versionGroup': versionGroup},
      ));

      if (result.data == null) {
        return '';
      }

      if (result
          .data!['pokemon_v2_pokemon'][0]['pokemon_v2_pokemonspecy']
              ['pokemon_v2_pokemonspeciesflavortexts']
          .isEmpty) {
        return '';
      }

      final flavorText = Utils.cleanFlavorText(
          result.data!['pokemon_v2_pokemon'][0]['pokemon_v2_pokemonspecy']
              ['pokemon_v2_pokemonspeciesflavortexts'][0]['flavor_text']);

      return flavorText;
    } catch (e) {
      throw Exception('Failed to fetch flavor text');
    }
  }

  List<PokemonMove> _extractMoves(List<dynamic> moves) {
    final List<PokemonMove> extractedMoves = [];

    for (final move in moves) {
      final name = move['pokemon_v2_move']['pokemon_v2_movenames'][0]['name'];
      final type = (move['pokemon_v2_move']['pokemon_v2_type']['name']);
      final level = move['level'];
      final machineNumber = move['pokemon_v2_move']['pokemon_v2_machines']
              .isNotEmpty
          ? move['pokemon_v2_move']['pokemon_v2_machines'][0]['machine_number']
          : null;
      final power = move['pokemon_v2_move']['power'];
      final pp = move['pokemon_v2_move']['pp'];
      final accuracy = move['pokemon_v2_move']['accuracy'];
      final method = move['pokemon_v2_movelearnmethod']['name'];
      final damageClass =
          move['pokemon_v2_move']['pokemon_v2_movedamageclass']['name'];

      extractedMoves.add(PokemonMove(
        name: name,
        type: type,
        level: level,
        machineNumber: machineNumber,
        power: power,
        pp: pp,
        accuracy: accuracy,
        method: method,
        damageClass: damageClass,
      ));
    }

    return extractedMoves;
  }

  List<int> _extractStats(List<dynamic> stats) {
    final List<int> extractedStats = [];

    for (final stat in stats) {
      extractedStats.add(stat['base_stat']);
    }

    return extractedStats;
  }

  List<PokemonAbility> _extractAbilities(List<dynamic> abilities) {
    final List<PokemonAbility> extractedAbilities = [];

    for (final ability in abilities) {
      final name =
          ability['pokemon_v2_ability']['pokemon_v2_abilitynames'][0]['name'];
      final isHidden = ability['is_hidden'];
      final flavorText =
          ability['pokemon_v2_ability']['pokemon_v2_abilityflavortexts'].isEmpty
              ? null
              : Utils.cleanFlavorText(ability['pokemon_v2_ability']
                  ['pokemon_v2_abilityflavortexts'][0]['flavor_text']);
      final effect =
          ability['pokemon_v2_ability']['pokemon_v2_abilityeffecttexts'].isEmpty
              ? null
              : Utils.cleanFlavorText(ability['pokemon_v2_ability']
                  ['pokemon_v2_abilityeffecttexts'][0]['effect']);

      extractedAbilities.add(PokemonAbility(
        name: name,
        isHidden: isHidden,
        flavorText: flavorText,
        effect: effect,
      ));
    }

    return extractedAbilities;
  }

  Future<PokemonNode> fetchPokemonEvolutions(int id) async {
    const query = '''
      query MyQuery(\$id: Int = 1) {
        pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
          name
          pokemon_v2_pokemonspecy {
            pokemon_v2_evolutionchain {
              pokemon_v2_pokemonspecies(order_by: {order: asc}) {
                order
                id
                pokemon_v2_pokemonspecies {
                  id
                }
                pokemon_v2_pokemons(limit: 1) {
                  id
                  pokemon_species_id
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
                  pokemon_v2_pokemonsprites {
                    sprites(path: "other.official-artwork.front_default")
                  }
                  pokemon_v2_pokemontypes {
                    pokemon_v2_type {
                      name
                    }
                  }
                }
              }
            }
          }
        }
      }
    ''';

    try {
      final result = await client.query(QueryOptions(
        document: gql(query),
        variables: {'id': id},
      ));

      final evolutions = result.data!['pokemon_v2_pokemon'][0]
              ['pokemon_v2_pokemonspecy']['pokemon_v2_evolutionchain']
          ['pokemon_v2_pokemonspecies'];

      final pokemonEvolutions = _extractEvolutions(evolutions);

      return pokemonEvolutions;
    } catch (e) {
      rethrow;
    }
  }

  PokemonNode _extractEvolutions(List<dynamic> evolutions) {
    final firstNode = _createPokemonNode(evolutions[0]);

    final queue = [firstNode];

    while (queue.isNotEmpty) {
      final current = queue.removeAt(0);
      final nextEvolutions = _findNextEvolutions(current, evolutions);

      current.evolutions = nextEvolutions;
      queue.addAll(nextEvolutions);
    }

    return firstNode;
  }

  PokemonNode _createPokemonNode(dynamic evolution) {
    return PokemonNode(
      pokemon: Pokemon.fromJson(evolution['pokemon_v2_pokemons'][0]),
      evolutions: null,
      evolutionIds: (evolution['pokemon_v2_pokemonspecies'] as List)
          .map((pokemon) => pokemon['id'] as int)
          .toList(),
    );
  }

  List<PokemonNode> _findNextEvolutions(
      PokemonNode current, List<dynamic> evolutions) {
    final List<PokemonNode> nextEvolutions = [];

    for (final evolution in evolutions) {
      if (current.evolutionIds.contains(evolution['id'])) {
        final nextPokemonNode = _createPokemonNode(evolution);
        nextEvolutions.add(nextPokemonNode);
      }
    }

    return nextEvolutions;
  }
}
