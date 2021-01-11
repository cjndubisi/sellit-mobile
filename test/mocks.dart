import 'package:flutter_starterkit_firebase/core/item_service.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_starterkit_firebase/utils/service_utility.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_starterkit_firebase/core/firebase_service.dart';
import 'package:flutter_starterkit_firebase/core/firestorage_service.dart';
import 'package:flutter_starterkit_firebase/core/firestore_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

typedef Callback = Function(MethodCall call);

void setupFirebaseAuthMocks([Callback customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });
}

class FirebaseAuthMock extends Mock implements FirebaseAuth {
  @override
  User get currentUser => UserMock();
}

class UserMock extends Mock implements User {
  @override
  String get displayName => 'Adeyemo Adeolu';

  @override
  String get email => 'adex9ja2@gmail.com';

  @override
  String get phoneNumber => '07056322027';

  @override
  String get uid => 'vibeibiebiebvie';

  @override
  String get photoURL => 'https://imageurl';
}

class FacebookLoginMock extends Mock implements FacebookLogin {}

class GoogleSignInMock extends Mock implements GoogleSignIn {}

class FirebaseAuthServiceMock extends Mock implements FirebaseService {}

class FirestoreServiceMock extends Mock implements FirestoreService {}

class FirebaseStorageServiceMock extends Mock implements FirebaseStorageService {}

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

class ServiceUtilityProviderMock extends Mock implements ServiceUtilityProvider {}

class ItemServiceMock extends Mock implements ItemService {}
