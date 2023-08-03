import 'package:network/http.dart';

import 'model/pkemon.dart';

class PokemonRepository {
  final HttpService client;

  PokemonRepository(this.client);

  Future<List<Pokemon>> getPokemons() async {
    final pokemonsJsonList = await client.get(path: '/api/v2/pokemon/');

    return pokemonsJsonList['results']
        .map<Pokemon>((pokemonJson) => Pokemon.fromJson(pokemonJson))
        .toList();
  }
}
