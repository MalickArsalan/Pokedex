part of 'pokemon_bloc.dart';

class PokemonState extends Equatable {
  const PokemonState(
      {this.pokemonApiState = const ApiState(),
      this.favPokemons = const [],
      this.isFav = const []});

  final ApiState<List<Pokemon>> pokemonApiState;
  final List<Pokemon> favPokemons;
  final List<bool> isFav;

  @override
  List<Object> get props => [pokemonApiState, favPokemons, isFav];

  PokemonState copyWith(
      {ApiState<List<Pokemon>>? pokemonApiState,
      List<Pokemon>? favPokemons,
      List<bool>? isFav}) {
    return PokemonState(
      pokemonApiState: pokemonApiState ?? this.pokemonApiState,
      favPokemons: favPokemons ?? this.favPokemons,
      isFav: isFav ?? this.isFav,
    );
  }
}
