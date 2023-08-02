part of 'authentication_bloc.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.email,
    this.password,
    this.submissionStatus = SubmissionStatus.idle,
  });

  final String? email;
  final String? password;
  final SubmissionStatus submissionStatus;

  AuthenticationState copyWith({
    String? email,
    String? password,
    SubmissionStatus? submissionStatus,
  }) {
    return AuthenticationState(
      email: email ?? this.email,
      password: password ?? this.password,
      submissionStatus: submissionStatus ?? this.submissionStatus,
    );
  }

  @override
  List<Object?> get props => [email, password, submissionStatus];
}

class LoginInitial extends AuthenticationState {}

enum SubmissionStatus {
  /// Used when the form has not been sent yet.
  idle,

  /// Used to disable all buttons and add a progress indicator to the main one.
  inProgress,

  /// Used to close the screen and navigate back to the caller screen.
  success,

  /// Used to display a generic snack bar saying that an error has occurred, e.g., no internet connection.
  genericError,

  /// Used to show a more specific error telling the user they got the email and/or password wrong.
  invalidCredentialsError,

  userAlreadyExists,
}
