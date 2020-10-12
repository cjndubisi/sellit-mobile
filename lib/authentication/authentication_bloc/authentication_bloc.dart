import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_starterkit_firebase/utils/repository.dart';
import 'package:meta/meta.dart';

import '../../core/auth_service.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required AuthService service})
      : assert(service != null),
        _service = service,
        super(null);

  final AuthService _service;

  @override
  Future<void> close() {
    return super.close();
  }

  AuthenticationState get initialState => UnInitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGoogleEvent();
    } else if (event is LoginWithFaceBookPressed) {
      yield* _mapLoginWithFaceBookPressedToState();
    } else if (event is LoginWithEmailPasswordPressed) {
      yield* _mapLoginWithEmailPassEvent(event.email, event.password);
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final bool isFirstTime = await Repository.getInstance().isFirstTime();
    if (isFirstTime) {
      yield UnInitialized();
    } else {
      final User user = _service.isSignedIn();
      if (user != null) {
        yield Authenticated();
      } else {
        yield UnAuthenticated();
      }
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated();
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
        yield Successful();
      else
        yield const Failed(message: 'Google sign in fails');
    } on CustomException catch (e) {
      yield Failed(message: e.cause);
    }
  }

  Stream<AuthenticationState> _mapLoginWithFaceBookPressedToState() async* {
    try {
      yield Loading();
      final UserCredential credential = await _service.faceBookSignIn();
      if (credential != null)
        yield Successful();
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
        yield Successful();
      else
        yield const Failed(message: 'Incorrect email or password!');
    } on CustomException catch (e) {
      yield Failed(message: e.cause);
    }
  }
}
