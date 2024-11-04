import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/utils.dart';

class PokemonDetailsRepository {
  final GraphQLClient client;

  PokemonDetailsRepository({required this.client});

  Future<String?> fetchInitialData(int id, String versionGroup) async {
    const query = '''
      query MyQuery(\$id: Int = 1, \$versionGroup: String = "red-blue") {
        pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
          name
          pokemon_v2_pokemonspecy {
            pokemon_v2_pokemonspeciesflavortexts(
              where: {
                pokemon_v2_version: {
                  pokemon_v2_versiongroup: {
                    name: {_eq: \$versionGroup}
                  }
                }, 
                pokemon_v2_language: {
                  name: {_eq: "en"}
                }
              }, 
              distinct_on: flavor_text
            ) {
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

      return Utils.cleanFlavorText(result.data!['pokemon_v2_pokemon'][0]
              ['pokemon_v2_pokemonspecy']
          ['pokemon_v2_pokemonspeciesflavortexts'][0]['flavor_text']);
    } catch (e) {
      rethrow;
    }
  }
}
