import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/Presentation/authentication/view/login_screen.dart';
import 'package:pokemon_repository/bloc/pokemon_bloc.dart';
import 'package:pokemon_repository/model/pkemon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:network/api_state.dart';

import '../../../utils/const.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<PokemonBloc, PokemonState>(
        listener: (context, state) {
          if (state.pokemonApiState.apiResponseState ==
              ApiResponseState.genericError) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Something went wrong. Please try again.")));
          }
        },
        builder: (context, state) {
          if (state.pokemonApiState.apiResponseState == ApiResponseState.idle) {
            BlocProvider.of<PokemonBloc>(context).add(const GetPokemonsEvent());
            return const Center(child: CircularProgressIndicator());
          }
          if (state.pokemonApiState.apiResponseState ==
              ApiResponseState.inProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.pokemonApiState.apiResponseState ==
              ApiResponseState.success) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              itemCount: state.pokemonApiState.response?.length,
              itemBuilder: (context, index) {
                return _buildRow(state.pokemonApiState.response![index],
                    state.isFav[index], context);
              },
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildRow(Pokemon pokemon, bool isFav, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: Colors.cyan,
        ),
      ),
      elevation: 4,
      shadowColor: Colors.grey,
      child: ListTile(
        title: Text(
          pokemon.name,
          style: const TextStyle(color: Colors.cyan),
        ),
        trailing: IconButton(
          icon: isFav
              ? const Icon(
                  Icons.favorite,
                  color: Colors.cyan,
                )
              : const Icon(
                  Icons.favorite_border,
                  color: Colors.cyan,
                ),
          onPressed: () {
            if (!isFav) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Added to favorites")));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Removed from favorites")));
            }
            BlocProvider.of<PokemonBloc>(context)
                .add(AddToFavoriteEvent(pokemon));
          },
        ),
      ),
    );
  }
}
