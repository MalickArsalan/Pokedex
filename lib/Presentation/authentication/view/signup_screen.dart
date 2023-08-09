import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pokedex/Presentation/Componenets/custom_text_field.dart';
import 'package:pokedex/Presentation/dashboard/bloc/bottom_navigation_bar_bloc.dart';
import 'package:pokedex/Presentation/dashboard/view/home_screen.dart';
import 'package:pokedex/utils/helper.dart';

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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => BottomNavigationBarBloc(),
                  child: HomeScreen(email: _email),
                ),
              ),
              (route) => false);
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
                      const CustomTextField(
                        name: 'email',
                        textInputType: TextInputType.emailAddress,
                        hintText: '📧 Email Address',
                        validatorFunction: emailValidator,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        name: 'password',
                        hintText: '🎹 password',
                        isObscureText: _obscureText,
                        sufficeIconWidget: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: _toggle,
                        ),
                        validatorFunction: passwordValidator,
                      ),
                      const SizedBox(height: 32),
                      if (state.submissionStatus == SubmissionStatus.inProgress)
                        const Center(child: CircularProgressIndicator())
                      else
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
}
