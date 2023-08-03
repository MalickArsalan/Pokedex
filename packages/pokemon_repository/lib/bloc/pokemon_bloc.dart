import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:network/api_state.dart';
import 'package:pokemon_repository/model/pkemon.dart';
import 'package:pokemon_repository/pokemon_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  PokemonBloc({required this.pokemonRepository, required this.FAV_KEY})
      : super(PokemonState()) {
    on<GetPokemonsEvent>(_getPokemons);
    on<AddToFavoriteEvent>(_addToFavorite);
  }

  final String FAV_KEY;
  final PokemonRepository pokemonRepository;

  Future<void> _getPokemons(
      GetPokemonsEvent event, Emitter<PokemonState> emit) async {
    try {
      emit(state.copyWith(
        pokemonApiState: const ApiState<List<Pokemon>>(
            apiResponseState: ApiResponseState.inProgress),
      ));

      final prefs = await SharedPreferences.getInstance();
      final favoriteKey = prefs.getString(FAV_KEY);
      final favPokemons = prefs.getString(favoriteKey!);

      final pokemons = await pokemonRepository.getPokemons();

      List<Pokemon>? favPokemonsList;
      if (favPokemons != null) {
        favPokemonsList = jsonDecode(favPokemons)[favoriteKey]
            .map<Pokemon>((pokemonJson) => Pokemon.fromJson(pokemonJson))
            .toList();
      }

      if (favPokemonsList != null) {
        emit(
          state.copyWith(
            isFav: pokemons.map((e) => favPokemonsList!.contains(e)).toList(),
            favPokemons: favPokemonsList,
            pokemonApiState: ApiState<List<Pokemon>>(
                response: pokemons, apiResponseState: ApiResponseState.success),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          isFav: pokemons.map((e) => false).toList(),
          pokemonApiState: ApiState<List<Pokemon>>(
              response: pokemons, apiResponseState: ApiResponseState.success),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          pokemonApiState: const ApiState<List<Pokemon>>(
              apiResponseState: ApiResponseState.genericError),
        ),
      );
    }
  }

  Future<void> _addToFavorite(
      AddToFavoriteEvent event, Emitter<PokemonState> emit) async {
    final pokemon = event.pokemon;

    var favPokemons = [...state.favPokemons];

    if (state.favPokemons.contains(pokemon)) {
      favPokemons.remove(pokemon);
    } else {
      favPokemons.add(pokemon);
    }

    final idx = state.pokemonApiState.response!.indexOf(pokemon);
    state.isFav[idx] = !state.isFav[idx];

    final prefs = await SharedPreferences.getInstance();
    final favoriteKey = prefs.getString(FAV_KEY);
    prefs.setString(favoriteKey!, jsonEncode({favoriteKey: favPokemons}));

    emit(
      state.copyWith(
        isFav: state.isFav,
        favPokemons: favPokemons,
        pokemonApiState: ApiState<List<Pokemon>>(
          response: state.pokemonApiState.response,
          apiResponseState: state.pokemonApiState.apiResponseState,
        ),
      ),
    );
  }
}
