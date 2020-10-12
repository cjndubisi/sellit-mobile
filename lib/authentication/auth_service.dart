import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_starterkit_firebase/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isSignedIn() {
    return _auth.currentUser != null;
  }

  User getUser() {
    if (_auth.currentUser == null) {
      return null;
    }
    return _auth.currentUser;
  }

  Future<bool> isFirstTime() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(Constants.FIRST_TIME) ?? true;
  }
}
