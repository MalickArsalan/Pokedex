part of 'pokemon_bloc.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object> get props => [];
}

class GetPokemonsEvent extends PokemonEvent {
  const GetPokemonsEvent();

  @override
  List<Object> get props => [];
}

class AddToFavoriteEvent extends PokemonEvent {
  const AddToFavoriteEvent(this.pokemon);

  final Pokemon pokemon;

  @override
  List<Object> get props => [pokemon];
}
