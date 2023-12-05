import 'package:todo/feature/data/model/user_credentials.dart';
import 'package:todo/feature/domain/repositories/auth_repository.dart';

class AuthUsecase {
  final AuthRepository _authRepository;

  AuthUsecase(this._authRepository);

  Future<void> signIn(UserCredentials userCredentials) =>
      _authRepository.signIn(userCredentials);

  Future<void> signUp(UserCredentials userCredentials) =>
      _authRepository.signUp(userCredentials);

  Future<void> signOut() =>
      _authRepository.signOut();
}
