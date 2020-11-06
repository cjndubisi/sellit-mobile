import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/core/auth_service.dart';
import 'package:flutter_starterkit_firebase/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mocks/firebase_auth_mock.dart';

final FirebaseAuthMock firebaseAuthMock = FirebaseAuthMock();
final GoogleSignInMock googleSignInMock = GoogleSignInMock();
final FacebookSignInMock facebookSignInMock = FacebookSignInMock();

final FirebaseMockAuthResult firebaseMockAuthResult = FirebaseMockAuthResult();
final GoogleUserMock googleUserMock = GoogleUserMock();
final AuthService auth = AuthService();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AuthenticationBloc authenticationBloc;
  AuthService _authService;
  FirebaseAuthServiceMock firebaseServiceMock;

  setUp(() {
    firebaseServiceMock = FirebaseAuthServiceMock();
    _authService = AuthService.fromFirebaseService(firebaseServiceMock);
    authenticationBloc = AuthenticationBloc(service: _authService);
    SharedPreferences.setMockInitialValues(<String, dynamic>{Constants.FIRST_TIME: false});
  });

  tearDown(() {
    authenticationBloc?.close();
  });

  group('auth bloc test', () {
    test('initial state is correct', () {
      expect(authenticationBloc.initialState, UnInitialized());
    });

    test('validate user signed in at app started', () {
      when(firebaseServiceMock.getCurrentUser()).thenAnswer((_) => FirebaseUserMock());

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Authenticated()]),
      );

      authenticationBloc.add(AppStarted());
    });

    test('successful login with email and password', () {
      when(firebaseServiceMock.signInWithEmailPassword('adex9ja2@gmail.com', '1111'))
          .thenAnswer((_) => Future.value(firebaseMockAuthResult));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Loading(), Successful()]),
      );

      authenticationBloc.add(LoginWithEmailPasswordPressed(email: 'adex9ja2@gmail.com', password: '1111'));
    });

    test('failed login with email / password', () {
      when(firebaseServiceMock.signInWithEmailPassword('adex9ja2@gmail.com', '1111'))
          .thenAnswer((_) => Future.value(firebaseMockAuthResult));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Loading(), const Failed(message: 'Incorrect email or password!')]),
      );

      authenticationBloc.add(LoginWithEmailPasswordPressed(email: 'adex9ja2@gmail.com', password: '1234'));
    });

    test('successful user registration', () {
      when(firebaseServiceMock.registerNewUser('adex9ja2@gmail.com', '1111'))
          .thenAnswer((_) => Future.value(firebaseMockAuthResult));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Loading(), Successful()]),
      );

      authenticationBloc.add(SubmitRegistrationPressed(
          email: 'adex9ja2@gmail.com', password: '1111', phonenumber: '08166767271', fullname: 'Adeyemo Adeolu'));
    });

    test('successful user registration', () {
      when(_authService.registerUser('adex9ja2@gmail.com', '1111', 'Adeyemo Adeolu', '08166767271'))
          .thenAnswer((_) => Future.value(firebaseMockAuthResult));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Loading(), Successful()]),
      );

      authenticationBloc.add(SubmitRegistrationPressed(
          email: 'adex9ja2@gmail.com', password: '1111', phonenumber: '08166767271', fullname: 'Adeyemo Adeolu'));
    });

    test('validate sign out', () {
      when(firebaseServiceMock.signOut()).thenAnswer((_) => Future.delayed(Duration.zero));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[UnAuthenticated()]),
      );

      authenticationBloc.add(LoggedOut());
    });
  });
}
