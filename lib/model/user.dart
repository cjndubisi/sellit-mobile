import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

class User {
  const User({
    @required this.uid,
    this.email,
    this.photoURL,
    this.displayName,
    this.name,
    this.phoneNumber,
  }) : assert(uid != null, 'User can only be created with a non-null uid');

  factory User.fromFirebaseUser(firebase_auth.User user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoURL: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  User.fromJson(Map<String, dynamic> json)
      : uid = json['uid'].toString(),
        email = json['email'].toString(),
        name = json['name'].toString(),
        displayName = json['displayName'].toString(),
        photoURL = json['photoURL'].toString(),
        phoneNumber = json['phoneNumber'].toString();

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'photoURL': photoURL,
      'name': name,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
    };
  }

  final String uid;
  final String name;
  final String email;
  final String photoURL;
  final String displayName;
  final String phoneNumber;

  @override
  String toString() =>
      'uid: $uid, email: $email, photoUrl: $photoURL, name: $name, displayName: $displayName, phoneNumber: $phoneNumber';
}
