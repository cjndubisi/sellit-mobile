import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/core/auth_service.dart';
import 'package:flutter_starterkit_firebase/core/listing_service.dart';
import 'package:flutter_starterkit_firebase/model/user.dart';
import 'package:flutter_starterkit_firebase/core/profile_service.dart';
import 'package:flutter_starterkit_firebase/listing/profile/bloc/profile_bloc.dart';
import 'package:flutter_starterkit_firebase/model/item_entity.dart';
import 'package:flutter_starterkit_firebase/utils/constants.dart';
import 'package:flutter_starterkit_firebase/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mocks.dart';

final FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
final GoogleSignInMock googleSignInMock = GoogleSignInMock();
final FacebookLoginMock facebookSignInMock = FacebookLoginMock();

final FirebaseMockAuthResult firebaseMockAuthResult = FirebaseMockAuthResult();
final GoogleUserMock googleUserMock = GoogleUserMock();
final AuthService auth = AuthService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  authBlocTest();
  profileBlocTest();
}

void authBlocTest() {
  AuthenticationBloc authenticationBloc;
  AuthService _authService;
  FirebaseAuthServiceMock firebaseServiceMock;
  const String email = 'adex9ja2@gmail.com';
  const String password = '1111';
  setUp(() {
    firebaseServiceMock = FirebaseAuthServiceMock();
    _authService = AuthService.fromFirebaseService(firebaseServiceMock);
    authenticationBloc = AuthenticationBloc(service: _authService, validators: Validators());
    SharedPreferences.setMockInitialValues(<String, dynamic>{Constants.FIRST_TIME: false});
  });

  group('auth bloc test', () {
    test('initial state is correct', () {
      expect(authenticationBloc.state, UnInitialized());
    });

    test('validate user signed in at app started', () {
      when(firebaseServiceMock.getCurrentUser()).thenAnswer((_) => User(uid: '22'));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Authenticated()]),
      );

      authenticationBloc.add(AppStarted());
    });

    test('successful login with email and password', () {
      when(firebaseServiceMock.signInWithEmailPassword(email, password))
          .thenAnswer((_) => Future.value(firebaseMockAuthResult));

      expectLater(
        authenticationBloc,
        emitsInOrder([
          isA<LoginFormState>()
              .having((state) => state.isBusy, 'loading', true)
              .having((state) => state.email, 'email', email)
              .having((state) => state.password, 'password', password),
          isA<LoginFormState>()
              .having((state) => state.isBusy, 'loading', false)
              .having((state) => state.isBusy, 'loading', false)
              .having((state) => state.email, 'email', email)
              .having((state) => state.password, 'password', password),
          Authenticated()
        ]),
      );

      authenticationBloc.add(LoginWithEmailPasswordPressed(email: email, password: password));
    });

    test('failed login with email / password', () {
      when(firebaseServiceMock.signInWithEmailPassword(email, password)).thenAnswer((_) => Future.value(null));

      expectLater(
        authenticationBloc,
        emitsInOrder([
          isA<LoginFormState>()
              .having((state) => state.isBusy, 'loading', true)
              .having((state) => state.formError, 'formError', isEmpty),
          isA<LoginFormState>()
              .having((state) => state.isBusy, 'loading', false)
              .having((state) => state.formError, 'formError', isNotEmpty),
        ]),
      );

      authenticationBloc.add(LoginWithEmailPasswordPressed(email: email, password: password));
    });

    test('successful user registration', () {
      when(_authService.registerUser('adex9ja2@gmail.com', '#Adeola123', 'Adeyemo Adeolu', '08166767271'))
          .thenAnswer((_) => Future.value(firebaseMockAuthResult));

      expectLater(
        authenticationBloc,
        emitsInOrder([
          isA<RegisterFormState>()
              .having((state) => state.isBusy, 'loading', true)
              .having((state) => state.formError, 'formError', isEmpty),
          Authenticated()
        ]),
      );

      authenticationBloc.add(SubmitRegistrationPressed(
          email: 'adex9ja2@gmail.com', password: '#Adeola123', phonenumber: '08166767271', fullname: 'Adeyemo Adeolu'));
    });

    test('validate sign out', () {
      when(firebaseServiceMock.signOut()).thenAnswer((_) => Future.delayed(Duration.zero));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[UnAuthenticated()]),
      );

      authenticationBloc.add(LogOutEvent());
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Invalid email format state',
      build: () {
        when(_authService.registerUser('adex9ja2@gmail', '#Adeola123', 'Adeyemo Adeolu', '08166767271'))
            .thenAnswer((_) => Future.value(firebaseMockAuthResult));
        return authenticationBloc;
      },
      act: (bloc) async => bloc.add(
        SubmitRegistrationPressed(
          email: 'adex9ja2@gmail',
          password: '#Adeola123',
          phonenumber: '08166767271',
          fullname: 'Adeyemo Adeolu',
        ),
      ),
      expect: [isA<RegisterFormState>().having((state) => state.isValidEmail, 'email valid', false)],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'Invalid password format state',
      build: () {
        when(_authService.registerUser('adex9ja2@gmail.com', 'Adeola123', 'Adeyemo Adeolu', '08166767271'))
            .thenAnswer((_) => Future.value(firebaseMockAuthResult));
        return authenticationBloc;
      },
      act: (bloc) async => bloc.add(SubmitRegistrationPressed(
        email: 'adex9ja2@gmail.com',
        password: 'Adeola123',
        phonenumber: '08166767271',
        fullname: 'Adeyemo Adeolu',
      )),
      expect: [isA<RegisterFormState>().having((state) => state.isValidPassword, 'password error', false)],
    );
  });

  tearDown(() {
    authenticationBloc?.close();
  });
}

void profileBlocTest() {
  ProfileBloc profileBloc;
  ProfileService _profileService;
  StreamController<List<ItemEntity>> streamController;
  setUp(() {
    streamController = StreamController<List<ItemEntity>>.broadcast();
    _profileService = ProfileService(
      ListingService(
        firebaseStorageService: FirebaseStorageServiceMock(),
        firestoreService: FirestoreServiceMock(),
      ),
    );
    profileBloc = ProfileBloc(service: _profileService);
    SharedPreferences.setMockInitialValues(<String, dynamic>{Constants.FIRST_TIME: false});
  });

  tearDown(() => profileBloc.close());
}
