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

  setUp(() {
    _authService = AuthService(firebase: firebaseAuthMock, google: googleSignInMock, facebook: facebookSignInMock);
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
      when(_authService.isSignedIn()).thenAnswer((_) => FirebaseUserMock());

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Authenticated()]),
      );

      authenticationBloc.add(AppStarted());
    });

    test('successful login with email and password', () {
      when(_authService.verifyUser('adex9ja2@gmail.com', '1111'))
          .thenAnswer((_) => Future<FirebaseMockAuthResult>.value(firebaseMockAuthResult));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Loading(), Successful()]),
      );

      authenticationBloc.add(LoginWithEmailPasswordPressed(email: 'adex9ja2@gmail.com', password: '1111'));
    });

    test('failed login with email / password', () {
      when(_authService.verifyUser('adex9ja2@gmail.com', '1111'))
          .thenAnswer((_) => Future.value(firebaseMockAuthResult));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[Loading(), const Failed(message: 'Incorrect email or password!')]),
      );

      authenticationBloc.add(LoginWithEmailPasswordPressed(email: 'adex9ja2@gmail.com', password: '1234'));
    });

    test('validate sign out', () {
      when(_authService.signOut()).thenAnswer((_) => Future<Duration>.delayed(Duration.zero));

      expectLater(
        authenticationBloc,
        emitsInOrder(<AuthenticationState>[UnAuthenticated()]),
      );

      authenticationBloc.add(LoggedOut());
    });
  });
}
