import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:network/http.dart';
import 'package:pokedex/Presentation/authentication/view/login_screen.dart';
import 'package:pokedex/Presentation/dashboard/view/favoritelist.dart';
import 'package:pokedex/Presentation/dashboard/view/pokemonlist.dart';
import 'package:pokedex/utils/const.dart';
import 'package:pokemon_repository/bloc/pokemon_bloc.dart';
import 'package:pokemon_repository/model/pkemon.dart';
import 'package:pokemon_repository/pokemon_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/bottom_sheet_bloc.dart';

List<BottomNavigationBarItem> bottomNavItems = const <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.list_alt_outlined),
    label: 'Pokemon',
  ),
  BottomNavigationBarItem(
    icon: Icon(Icons.favorite_outlined),
    label: 'Favorites',
  ),
];

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    String _email = this.email;
    List<Pokemon> _favpokemons = [];
    return BlocConsumer<BottomSheetBloc, BottomSheetState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: const Text(
              'Pokemon List',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    SharedPreferences.getInstance().then((pref) {
                      pref.remove(LOGIN_KEY);
                    });

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (route) => false);
                  },
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
          body: IndexedStack(
            index: state.tabIndex,
            children: <Widget>[
              BlocProvider(
                create: (context) => PokemonBloc(
                  pokemonRepository: PokemonRepository(
                    HttpService(
                      client: Client(),
                    ),
                  ),
                  FAV_KEY: LOGIN_KEY,
                ),
                child: const PokemonList(),
              ),
              FavoriteScreen(favorites: _favpokemons)
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavItems,
            currentIndex: state.tabIndex,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            onTap: (index) async {
              if (index == 1) {
                final prefs = await SharedPreferences.getInstance();
                final favoriteKey = prefs.getString(_email);
                if (favoriteKey != null) {
                  _favpokemons = jsonDecode(favoriteKey)[_email]
                      .map<Pokemon>(
                          (pokemonJson) => Pokemon.fromJson(pokemonJson))
                      .toList();
                }
              }
              BlocProvider.of<BottomSheetBloc>(context)
                  .add(TabChange(tabIndex: index));
            },
          ),
        );
      },
    );
  }
}
