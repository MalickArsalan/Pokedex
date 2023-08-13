part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class LoginCredentialsEvent extends AuthenticationEvent {
  const LoginCredentialsEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class LoginCompleteEvent extends AuthenticationEvent {
  const LoginCompleteEvent();
}

class SignupCredentialsEvent extends AuthenticationEvent {
  const SignupCredentialsEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
