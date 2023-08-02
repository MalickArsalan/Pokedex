import 'package:authentication_repository/authentication_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'authentication/view/login_screen.dart';
import 'utils/const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(
        authenticationRepository:
            AuthenticationRepository(FirebaseAuth.instance),
      ),
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: FutureBuilder<bool?>(
            future: _isHome(),
            builder: (context, snapshot) {
              return const LoginScreen();
            }),
      ),
    );
  }

  Future<bool?> _isHome() async {
    final pref = await SharedPreferences.getInstance();

    return pref.getBool(LOGIN_KEY);
  }
}
