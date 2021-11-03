import 'dart:developer';

import 'package:bookario/app.locator.dart';
import 'package:bookario/models/user_model.dart';
import 'package:bookario/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseService _firebaseService = locator<FirebaseService>();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential authResult =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _populateCurrentUser(authResult.user);
      return authResult.user;
    } on FirebaseAuthException catch (e) {
      log(e.message.toString());
      return null;
    }
  }

  Future<bool> signUpWithEmail({
    required UserModel user,
    required String password,
  }) async {
    try {
      final UserCredential authResult =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      _currentUser = UserModel(
        id: authResult.user!.uid,
        name: user.name,
        phone: user.phone,
        email: user.email,
        age: user.age,
        gender: user.gender,
      );

      //Create new user document using FireStoreService
      await _firebaseService.createUser(_currentUser!);

      return authResult.user != null;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return false;
    }
  }

  Stream<User?> get userState => _firebaseAuth.authStateChanges();

  Future<bool> checkUserLoggedIn() async {
    final user = _firebaseAuth.currentUser;
    await _populateCurrentUser(user);
    return user != null;
  }

  Future userLogout() async {
    await _firebaseAuth.signOut();
  }

  Future _populateCurrentUser(User? user) async {
    if (user != null) {
      _currentUser = await _firebaseService.getUserProfile(user.uid);
    }
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
