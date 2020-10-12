import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_starterkit_firebase/utils/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();

  Future<User> userFromGoogleCredentials(AuthCredential credential) async {
    final UserCredential result = await _auth.signInWithCredential(credential);
    _updateUserData(result.user);

    return result.user;
  }

  void _updateUserData(User user) {
    final DocumentReference ref = _db.collection('users').doc(user.uid);
    ref.set(<String, dynamic>{
      'displayName': user.displayName,
      'email': user.email,
    });
  }

  Future<void> signOut() async {
    return Future.wait([_auth.signOut(), _googleSignIn.signOut(), _facebookLogin.logOut()]);
  }

  Future<bool> isSignedIn() async {
    return _auth.currentUser != null;
  }

  Future<String> getUser() async {
    return _auth.currentUser.email;
  }

  Future<bool> isFirstTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(Constants.FIRST_TIME) ?? true;
  }

  Future<UserCredential> faceBookSignIn() async {
    final result = await _facebookLogin.logIn(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      AuthCredential credential = FacebookAuthProvider.credential(result.accessToken.token);
      return _auth.signInWithCredential(credential);
    } else
      return null;
  }

  Future<UserCredential> googleSignIn() async {
    var googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential authCredential =
          GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      return _auth.signInWithCredential(authCredential);
    } else
      return null;
  }

  Future<UserCredential> verifyUser(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void onError(Object obj) {
    if (obj is FirebaseAuthException)
      loadingFailed(obj.message);
    else
      loadingFailed("Error Occurs!");
  }

  Future<User> registerUser(String email, String password, String fullName, String phoneno) async {
    var value = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    if (value?.user != null) {
      return value?.user;
    } else
      return null;
  }

  Future<void> forgotPassword(String email, BuildContext context) async {
    await startLoading(context);
    _auth.sendPasswordResetEmail(email: email).then(passwordResetResponse).catchError(onError);
  }

  FutureOr<void> passwordResetResponse(void value) {
    loadingSuccessful("Password reset mail sent!");
  }
}
