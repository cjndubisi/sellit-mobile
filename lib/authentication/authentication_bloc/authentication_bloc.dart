import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' show UserCredential;
import 'package:flutter_starterkit_firebase/core/auth_service.dart';
import 'package:flutter_starterkit_firebase/model/user.dart';
import 'package:flutter_starterkit_firebase/utils/repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required AuthService service})
      : assert(service != null),
        _service = service,
        super(UnInitialized());

  final AuthService _service;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield Authenticated();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGoogleEvent();
    } else if (event is LoginWithFacebookPressed) {
      yield* _mapLoginWithFaceBookPressedToState();
    } else if (event is LoginWithEmailPasswordPressed) {
      yield* _mapLoginWithEmailPassEvent(event.email, event.password);
    } else if (event is SubmitRegistrationPressed) {
      yield* _mapRegisterUserToState(event.email, event.fullname, event.phonenumber, event.password);
    } else if (event is OnBoardingCompleted) {
      yield* _mapOnBoardingCompletedToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final bool isFirstTime = await Repository.getInstance().isFirstTime();
    if (isFirstTime) {
      yield UnInitialized();
    }
    final User user = _service.getUser();

    if (user == null) {
      yield UnAuthenticated();
      return;
    }
    yield Authenticated(user: user);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    _service.signOut();
    yield UnAuthenticated();
  }

  Stream<AuthenticationState> _mapLoginWithGoogleEvent() async* {
    try {
      yield Loading();
      final UserCredential credential = await _service.googleSignIn();
      if (credential != null)
        yield Authenticated(user: User.fromFirebaseUser(credential.user));
      else
        yield const Failed(message: 'Google sign in fails!');
    } on CustomException catch (e) {
      yield Failed(message: e.cause);
    }
  }

  Stream<AuthenticationState> _mapLoginWithFaceBookPressedToState() async* {
    try {
      yield Loading();
      final UserCredential credential = await _service.facebookSignIn();
      if (credential != null)
        yield Authenticated(user: User.fromFirebaseUser(credential.user));
      else
        yield const Failed(message: 'Facebook sign in fails!');
    } on CustomException catch (e) {
      yield Failed(message: e.cause);
    }
  }

  Stream<AuthenticationState> _mapLoginWithEmailPassEvent(String email, String password) async* {
    try {
      yield Loading();
      final UserCredential credential = await _service.verifyUser(email, password);
      if (credential != null)
        yield Authenticated(user: User.fromFirebaseUser(credential.user));
      else
        yield const Failed(message: 'Incorrect email or password!');
    } on CustomException catch (e) {
      yield Failed(message: e.cause);
    }
  }

  Stream<AuthenticationState> _mapRegisterUserToState(
    String email,
    String fullname,
    String phonenumber,
    String password,
  ) async* {
    try {
      yield Loading();
      final UserCredential credential = await _service.registerUser(email, password, fullname, phonenumber);
      if (credential != null)
        yield Authenticated(user: User.fromFirebaseUser(credential.user));
      else
        yield const Failed(message: 'Incorrect email or password!');
    } on CustomException catch (e) {
      yield Failed(message: e.cause);
    }
  }

  // ignore: unused_element
  Stream<AuthenticationState> _mapForgotPassword(String email) async* {
    try {
      yield Loading();
      _service.forgotPassword(email);
      yield Successful();
    } on CustomException catch (e) {
      yield Failed(message: e.cause);
    }
  }

  Stream<AuthenticationState> _mapOnBoardingCompletedToState() async* {
    await Repository.getInstance().onBoardingCompleted();
    yield UnAuthenticated();
  }
}
