import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:trainerdex/utils.dart';

class PokemonDetailsRepository {
  final GraphQLClient client;

  PokemonDetailsRepository({required this.client});

  Future<(String?, int, int, int, String)> fetchInitialData(
      int id, String versionGroup) async {
    const query = '''
      query MyQuery(\$id: Int = 1, \$versionGroup: String = "red-blue") {
        pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
          name
          height
          weight
          base_experience
          pokemon_v2_pokemoncries {
            cries(path: "latest")
          }
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

      final flavorText = Utils.cleanFlavorText(
          result.data!['pokemon_v2_pokemon'][0]['pokemon_v2_pokemonspecy']
              ['pokemon_v2_pokemonspeciesflavortexts'][0]['flavor_text']);

      final int height = result.data!['pokemon_v2_pokemon'][0]['height'];
      final int weight = result.data!['pokemon_v2_pokemon'][0]['weight'];
      final int baseExperience =
          result.data!['pokemon_v2_pokemon'][0]['base_experience'];
      final String cries = result.data!['pokemon_v2_pokemon'][0]
          ['pokemon_v2_pokemoncries'][0]['cries'];

      return (flavorText, height, weight, baseExperience, cries);
    } catch (e) {
      rethrow;
    }
  }
}
