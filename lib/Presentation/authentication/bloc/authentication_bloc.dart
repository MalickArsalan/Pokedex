import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokedex/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({required this.authenticationRepository})
      : super(LoginInitial()) {
    on<LoginCredentialsEvent>(_signIn);
    on<SignupCredentialsEvent>(_signup);
    on<LoginCompleteEvent>(_siginInComplete);
  }

  final AuthenticationRepository authenticationRepository;

  Future<void> _signIn(
    LoginCredentialsEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
    try {
      await authenticationRepository.firebaseLogin(
        event.email,
        event.password,
      );
      final pref = await SharedPreferences.getInstance();
      pref.setString(LOGIN_KEY, event.email);
      // pref.setString(event.email, event.email);
      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } on FirebaseAuthException catch (authException) {
      emit(state.copyWith(
          submissionStatus: SubmissionStatus.invalidCredentialsError));
    } catch (e) {
      emit(state.copyWith(submissionStatus: SubmissionStatus.genericError));
    }
  }

  Future<void> _siginInComplete(
    LoginCompleteEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.idle));
  }

  Future<void> _signup(
    SignupCredentialsEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(submissionStatus: SubmissionStatus.inProgress));
    try {
      await authenticationRepository.firebaseSignup(
        event.email,
        event.password,
      );
      final pref = await SharedPreferences.getInstance();
      pref.setString(LOGIN_KEY, event.email);
      // pref.setString(event.email, event.email);
      emit(state.copyWith(submissionStatus: SubmissionStatus.success));
    } on FirebaseAuthException catch (authException) {
      switch (authException.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          emit(state.copyWith(
              submissionStatus: SubmissionStatus.userAlreadyExists));
          break;
        default:
          emit(state.copyWith(
              submissionStatus: SubmissionStatus.invalidCredentialsError));
      }
    } catch (e) {
      emit(state.copyWith(submissionStatus: SubmissionStatus.genericError));
    }
  }
}
