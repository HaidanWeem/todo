import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class Pending extends AuthState {
  const Pending();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthLoaded extends AuthState {
  const AuthLoaded();
}

class AuthError extends AuthState {
  final String error;

  const AuthError({required this.error});
}
