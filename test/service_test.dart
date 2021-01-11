import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_starterkit_firebase/core/auth_service.dart';
import 'package:flutter_starterkit_firebase/core/firestore_service.dart';
import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/core/profile_service.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks.dart';

FirebaseAuthMock firebaseAuthMock;
GoogleSignInMock googleSignInMock;
FacebookLoginMock facebookSignInMock;
GoogleUserMock googleUserMock;
FirebaseMockAuthResult firebaseMockAuthResult;
FirebaseAuthServiceMock firebaseServiceMock;
AuthService _authService;
ProfileService _profileService;
StreamController<List<ItemEntity>> streamController;
FirestoreService firestoreServiceMock;
ListingService listingService;
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  authServiceTest();
  profileService();
}

void authServiceTest() {
  setUp(() {
    firebaseAuthMock = FirebaseAuthMock();
    googleSignInMock = GoogleSignInMock();
    facebookSignInMock = FacebookLoginMock();
    googleUserMock = GoogleUserMock();
    firebaseMockAuthResult = FirebaseMockAuthResult();
    firebaseServiceMock = FirebaseAuthServiceMock();
    firestoreServiceMock = FirestoreServiceMock();
    listingService = ListingService(
      firebaseStorageService: FirebaseStorageServiceMock(),
      firestoreService: firestoreServiceMock,
    );
    _authService = AuthService.fromFirebaseService(firebaseServiceMock);
  });

  group('auth unit test', () {
    test('failed login with email / password', () async {
      final UserCredential signedIn = await _authService.verifyUser('mail', 'pass');
      assert(signedIn == null);
    });

    test('successful user registration', () async {
      when(_authService.registerUser('adex9ja@yahoo.com', '1111', 'Adeyemo Adeolu', '08166767271'))
          .thenAnswer((_) async {
        return firebaseMockAuthResult;
      });

      final UserCredential userRegistered =
          await _authService.registerUser('adex9ja@yahoo.com', '1111', 'Adeyemo Adeolu', '08166767271');
      assert(userRegistered != null);
      expect(userRegistered, firebaseMockAuthResult);
    });

    test('validate sign out', () async {
      when(firebaseServiceMock.signOut()).thenAnswer((_) async {
        return null;
      });

      await _authService.signOut();
    });

    test('signInWithGoogle', () async {
      when(firebaseServiceMock.googleSignIn()).thenAnswer(
        (_) => Future<FirebaseMockAuthResult>.value(firebaseMockAuthResult),
      );

      await _authService.googleSignIn();
    });
  });
}

void profileService() {
  setUp(() {
    firebaseAuthMock = FirebaseAuthMock();
    googleSignInMock = GoogleSignInMock();
    facebookSignInMock = FacebookLoginMock();
    googleUserMock = GoogleUserMock();
    firebaseMockAuthResult = FirebaseMockAuthResult();
    firebaseServiceMock = FirebaseAuthServiceMock();
    firestoreServiceMock = FirestoreServiceMock();
    streamController = StreamController<List<ItemEntity>>.broadcast();
    _profileService = ProfileService(
      ListingService(
        firebaseStorageService: FirebaseStorageServiceMock(),
        firestoreService: firestoreServiceMock,
      ),
    );
  });

  group('user profile unit tests', () {
    test('get user items success', () {
      when(firestoreServiceMock.collectionStream(
        path: anyNamed('path'),
        builder: anyNamed('builder'),
        queryBuilder: anyNamed('queryBuilder'),
      )).thenAnswer((_) => streamController.stream);

      expect(_profileService.getUserItems(Constants.Live), streamController.stream);
    });
  });
}
