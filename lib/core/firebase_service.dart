import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  FirebaseService({
    FirebaseAuth firebaseAuth,
    FacebookLogin facebookSignIn,
    GoogleSignIn googleSignIn,
  })  : _auth = firebaseAuth ?? FirebaseAuth.instance,
        _facebookLogin = facebookSignIn ?? FacebookLogin(),
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final FacebookLogin _facebookLogin;
  final GoogleSignIn _googleSignIn;

  Future<void> signOut() async {
    return Future.wait([_auth.signOut(), _facebookLogin.logOut(), _facebookLogin.logOut()]);
  }

  User getCurrentUser() {
    return _auth?.currentUser;
  }

  String getUserDisplayName() {
    return _auth.currentUser?.email;
  }

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    return await _auth?.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> registerNewUser(String email, String password) async {
    return await _auth?.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> facebookSignIn() async {
    final result = await _facebookLogin.logIn(['email']);
    if (result?.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
      return await _auth?.signInWithCredential(credential);
    } else {
      return null;
    }
  }

  Future<UserCredential> googleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return null;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential authCredential =
        GoogleAuthProvider.credential(idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
    return await _auth.signInWithCredential(authCredential);
  }

  Future<void> forgotPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }
}
