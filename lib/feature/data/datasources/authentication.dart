import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/feature/data/model/user_credentials.dart';

abstract class Authentication {
  Future<void> signIn(UserCredentials user);
  Future<void> signUp(UserCredentials user);
  Future<void> signOut();
}

class AuthenticationImpl implements Authentication {
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseFirestore.instance;

  @override
  Future<void> signIn(UserCredentials user) => _auth.signInWithEmailAndPassword(
      email: user.email ?? '', password: user.password ?? '');

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> signUp(UserCredentials userCredentials) async {
    final userCreds = await _auth.createUserWithEmailAndPassword(
        email: userCredentials.email ?? '',
        password: userCredentials.password ?? '');

    await _storage.collection('users').doc(userCreds.user?.uid).set({
      'email': userCredentials.email,
      'nickName': userCredentials.nickName,
    });
  }
}
