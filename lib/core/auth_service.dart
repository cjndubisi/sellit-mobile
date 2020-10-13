import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_service.dart';

class AuthService {
  AuthService({
    FirebaseAuth firebase,
    FacebookLogin facebook,
    GoogleSignIn google,
  }) : _auth = FirebaseService(
          firebaseAuth: firebase,
          facebookSignIn: facebook,
          googleSignIn: google,
        );

  AuthService.fromFirebaseService(FirebaseService auth)
      : assert(auth != null),
        _auth = auth;

  final FirebaseService _auth;

  FirebaseAuth get auth => _auth.instance;

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  User getUser() {
    return _auth.getCurrentUser();
  }

  bool isSignedIn() {
    return getUser() != null;
  }

  Future<UserCredential> facebookSignIn() async {
    try {
      final UserCredential response = await _auth.facebookSignIn();
      return response;
    } on Exception catch (e) {
      return throw CustomException(e.toString());
    }
  }

  Future<UserCredential> googleSignIn() async {
    try {
      final UserCredential response = await _auth.googleSignIn();
      return response;
    } on Exception catch (e) {
      return throw CustomException(e.toString());
    }
  }

  Future<UserCredential> verifyUser(String email, String password) async {
    try {
      final UserCredential response = await _auth.signInWithEmailPassword(email, password);
      return response;
    } on Exception catch (e) {
      return throw CustomException(e.toString());
    }
  }

  Future<UserCredential> registerUser(String email, String password, String fullName, String phoneno) async {
    try {
      final UserCredential user = await _auth.registerNewUser(email, password);
      // TODO(handleRegisteredUser): Grab the returned user and send to server/save to FireStore
      return user;
    } on Exception catch (e) {
      return throw CustomException(e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    await _auth.forgotPassword(email);
  }
}

class CustomException implements Exception {
  CustomException(this.cause);
  final String cause;
}
