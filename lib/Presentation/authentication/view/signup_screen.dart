import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pokedex/Presentation/dashboard/bloc/bottom_sheet_bloc.dart';
import 'package:pokedex/Presentation/dashboard/view/home_screen.dart';

import '../bloc/authentication_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool _obscureText = true;
  String _email = '';

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
        if (state.submissionStatus == SubmissionStatus.genericError) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Something went wrong. Please try again.')));
        }
        if (state.submissionStatus ==
            SubmissionStatus.invalidCredentialsError) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid email or password.')));
        }
        if (state.submissionStatus == SubmissionStatus.success) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => BottomSheetBloc(),
                      child: HomeScreen(email: _email),
                    )),
          );
        }
      }, builder: (context, state) {
        return SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusScopeNode());
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: FormBuilder(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.only(top: 48.0),
                    children: [
                      const SizedBox(
                        height: 200,
                        child: Image(
                          image: AssetImage(
                            'assets/pokedex_assets/pokdex.png',
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      buildEmailField('📧 Email Address'),
                      const SizedBox(height: 16),
                      buildPasswordField('🎹 password'),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.saveAndValidate()) {
                            // Perform login logic
                            final formData = _formKey.currentState!.value;
                            final email = formData['email'] as String;
                            final password = formData['password'] as String;
                            _email = email;
                            BlocProvider.of<AuthenticationBloc>(context).add(
                              SignupCredentialsEvent(
                                email: email,
                                password: password,
                              ),
                            );
                          }
                        },
                        style: const ButtonStyle(
                          foregroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          fixedSize: MaterialStatePropertyAll(Size(0, 48)),
                        ),
                        child: const Text(
                          'Signup',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildEmailField(String hintText) {
    return FormBuilderTextField(
        name: 'email',
        style: const TextStyle(color: Colors.cyan),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.cyan),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: hintText,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.cyan,
              width: 1.0,
            ),
          ),
        ),
        validator: (email) {
          // email regex
          final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

          // validate email
          if (email == null || email.isEmpty) {
            return 'Email is required';
          } else if (!emailRegex.hasMatch(email)) {
            return 'Email is invalid';
          } else {
            return null;
          }
        });
  }

  Widget buildPasswordField(String hintText) {
    return FormBuilderTextField(
      name: 'password',
      style: const TextStyle(color: Colors.cyan),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.cyan),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        labelText: hintText,
        filled: true,
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
          onPressed: _toggle,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.cyan,
            width: 1.0,
          ),
        ),
      ),
      obscureText: _obscureText,
      validator: (password) {
        if (password == null || password.length < 8) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
    );
  }
}
