import 'package:todo/feature/data/datasources/authentication.dart';
import 'package:todo/feature/data/model/user_credentials.dart';
import 'package:todo/feature/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final Authentication _auth;

  AuthRepositoryImpl(this._auth);

  @override
  Future<void> signIn(UserCredentials userCredentials) =>
      _auth.signIn(userCredentials);

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> signUp(UserCredentials userCredentials) async {
    await _auth.signUp(userCredentials);
  }
}
