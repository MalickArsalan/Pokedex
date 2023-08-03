import 'package:flutter/material.dart';
import 'package:pokemon_repository/model/pkemon.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key, required this.favorites});

  final List<Pokemon> favorites;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return _buildRow(favorites[index]);
            }));
  }

  Widget _buildRow(Pokemon pokemon) {
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
      ),
    );
  }
}
