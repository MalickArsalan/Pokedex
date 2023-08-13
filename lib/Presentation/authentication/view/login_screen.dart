import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pokedex/Presentation/Componenets/custom_text_field.dart';
import 'package:pokedex/Presentation/authentication/view/signup_screen.dart';
import 'package:pokedex/Presentation/dashboard/bloc/bottom_navigation_bar_bloc.dart';
import 'package:pokedex/Presentation/dashboard/view/home_screen.dart';

import '../../../utils/helper.dart';
import '../bloc/authentication_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool _obscureText = true;
  String _email = '';

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    BlocProvider.of<AuthenticationBloc>(context).add(LoginCompleteEvent());
    super.initState();
  }

  final items = const [Text('1'), Text('2')];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);

    double width = (MediaQuery.of(context).size.width);
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
                    child: HomeScreen(
                      email: _email,
                    ),
                  ),
                ),
                (route) => false);
          }
        },
        builder: (context, state) {
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
                        const SizedBox(height: 16),
                        state.submissionStatus == SubmissionStatus.inProgress ||
                                state.submissionStatus ==
                                    SubmissionStatus.success
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!
                                          .saveAndValidate()) {
                                        // Perform login logic
                                        final formData =
                                            _formKey.currentState!.value;
                                        final email =
                                            formData['email'] as String;
                                        final password =
                                            formData['password'] as String;
                                        _email = email;
                                        BlocProvider.of<AuthenticationBloc>(
                                                context)
                                            .add(
                                          LoginCredentialsEvent(
                                            email: email,
                                            password: password,
                                          ),
                                        );
                                      }
                                    },
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStatePropertyAll(
                                          Colors.white),
                                      fixedSize: MaterialStatePropertyAll(
                                          Size(width, 48)),
                                    ),
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: 'Don\'t have an account? ',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        TextSpan(
                                          text: 'Sign up',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BlocProvider.value(
                                                    value: context.read<
                                                        AuthenticationBloc>(),
                                                    child: const SignupScreen(),
                                                  ),
                                                ),
                                              );
                                            },
                                          style: const TextStyle(
                                              color: Colors.cyan),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
