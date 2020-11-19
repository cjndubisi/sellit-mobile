import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_service.dart';

class AuthService {
  AuthService() : _firebaseService = FirebaseService();

  AuthService.fromFirebaseService(FirebaseService auth)
      : assert(auth != null),
        _firebaseService = auth;

  final FirebaseService _firebaseService;

  Future<void> signOut() async {
    return await _firebaseService.signOut();
  }

  User getUser() {
    return _firebaseService.getCurrentUser();
  }

  bool isSignedIn() {
    return getUser() != null;
  }

  Future<UserCredential> facebookSignIn() async {
    try {
      final UserCredential response = await _firebaseService.facebookSignIn();
      return response;
    } on Exception catch (e) {
      return throw CustomException(e.toString());
    }
  }

  Future<UserCredential> googleSignIn() async {
    try {
      final UserCredential response = await _firebaseService.googleSignIn();
      return response;
    } on Exception catch (e) {
      return throw CustomException(e.toString());
    }
  }

  Future<UserCredential> verifyUser(String email, String password) async {
    try {
      final UserCredential response = await _firebaseService.signInWithEmailPassword(email, password);
      return response;
    } on Exception catch (e) {
      return throw CustomException(e.toString());
    }
  }

  Future<UserCredential> registerUser(String email, String password, String fullName, String phoneno) async {
    try {
      final UserCredential user = await _firebaseService.registerNewUser(email, password);
      // TODO(handleRegisteredUser): Grab the returned user and send to server/save to FireStore
      return user;
    } on Exception catch (e) {
      return throw CustomException(e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    await _firebaseService.forgotPassword(email);
  }
}

class CustomException implements Exception {
  CustomException(this.cause);
  final String cause;
}
