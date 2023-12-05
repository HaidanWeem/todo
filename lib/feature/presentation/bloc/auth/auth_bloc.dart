import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/feature/data/model/user_credentials.dart';
import 'package:todo/feature/domain/usecases/auth_usercase.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_event.dart';
import 'package:todo/feature/presentation/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecase _authUsecase;

  AuthBloc(this._authUsecase) : super(const Pending()) {
    on<SignUpEvent>(
      (event, emit) async {
        try {
          emit(const AuthLoading());
          await _authUsecase.signUp(UserCredentials(
            email: event.email,
            password: event.password,
            nickName: event.nickName,
          ));

          emit(const AuthLoaded());
        } catch (e) {
          emit(AuthError(error: e.toString()));
          emit(const Pending());
        }
      },
    );

    on<SignInEvent>(
      (event, emit) async {
        try {
          emit(const AuthLoading());
          await _authUsecase.signIn(UserCredentials(
            email: event.email,
            password: event.password,
          ));

          emit(const AuthLoaded());
        } catch (e) {
          emit(AuthError(error: e.toString()));
          emit(const Pending());
        }
      },
    );

    on<SignOutEvent>(
      (_, emit) async {
        try {
          emit(const AuthLoading());
          await _authUsecase.signOut();
          emit(const AuthLoaded());
        } catch (e) {
          emit(AuthError(error: e.toString()));
          emit(const Pending());
        }
      },
    );
  }
}
