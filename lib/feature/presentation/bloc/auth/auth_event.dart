import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoadingEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [];
}


class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String nickName;

  const SignUpEvent({
    required this.email,
    required this.nickName,
    required this.password,
  });

  @override
  List<Object> get props => [];
}

class SignOutEvent extends AuthEvent {}

