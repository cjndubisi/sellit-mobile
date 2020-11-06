import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_starterkit_firebase/core/firebase_service.dart';
import 'package:flutter_starterkit_firebase/core/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class FacebookSignInMock extends Mock implements FacebookLogin {}

class GoogleSignInMock extends Mock implements GoogleSignIn {}

class FirebaseAuthServiceMock extends Mock implements FirebaseService {}

class FirestoreServiceMock extends Mock implements FirestoreService {}

class AuthCredentialMock extends Mock implements AuthCredential {
  @override
  int get token => 1000;
}

class FirebaseMockAuthResult extends Mock implements UserCredential {
  String get displayName => 'Adeyemo Adeolu';

  @override
  AuthCredential get credential => AuthCredentialMock();

  String get email => 'adex9ja2@gmail.com';
}

class FirebaseUserMock extends Mock implements User {
  @override
  String get displayName => 'Adeyemo Adeolu';

  @override
  String get email => 'adex9ja2@gmail.com';
}

class GoogleUserMock extends Mock implements GoogleSignInAccount, UserCredential {
  @override
  String get displayName => 'Adeyemo Adeolu';

  @override
  String get email => 'adex9ja2@gmail.com';
}
