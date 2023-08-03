import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            height: 100,
            child: Image(
              image: AssetImage(
                'assets/pokedex_assets/pokemon-ball.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}