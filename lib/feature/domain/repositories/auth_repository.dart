import 'package:todo/feature/data/model/user_credentials.dart';

abstract class AuthRepository {
  Future<void> signIn(UserCredentials userCredentials);
  Future<void> signUp(UserCredentials userCredential);
  Future<void> signOut();
}
