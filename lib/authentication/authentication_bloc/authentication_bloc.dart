import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter_starterkit_firebase/core/auth_service.dart';
import 'package:flutter_starterkit_firebase/model/user.dart';
import 'package:flutter_starterkit_firebase/utils/repository.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';
import 'package:flutter_starterkit_firebase/utils/validators.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({@required AuthService service, @required Validators validators})
      : assert(service != null),
        assert(validators != null),
        _validators = validators,
        _service = service,
        super(UnInitialized());

  final AuthService _service;
  final Validators _validators;
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield Authenticated();
    } else if (event is LogOutEvent) {
      yield* _mapLoggedOutToState();
    } else if (event is LoginWithGooglePressed) {
      yield* _mapLoginWithGoogleEvent();
    } else if (event is LoginWithFacebookPressed) {
      yield* _mapLoginWithFaceBookPressedToState();
    } else if (event is LoginWithEmailPasswordPressed) {
      yield* _mapLoginWithEmailPassEvent(event);
    } else if (event is SubmitRegistrationPressed) {
      yield* _mapRegisterUserToState(event);
    } else if (event is OnBoardingCompleted) {
      yield* _mapOnBoardingCompletedToState();
    } else if (event is LoginFormValueChangedEvent) {
      yield* _mapLoginFormValueChangedEventToState(event);
    }
  }

  Stream<AuthenticationState> _mapLoginFormValueChangedEventToState(LoginFormValueChangedEvent event) async* {
    final LoginFormState currentState = tryCast<LoginFormState>(state) ?? LoginFormState();

    yield currentState.copyWith(
        email: event.email,
        password: event.password,
        emailError: _validators.validateEmail(value: event.email),
        passwordError: _validators.validatePassword(value: event.password),
        formError: '');
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final bool isFirstTime = await Repository.getInstance().isFirstTime();
    if (isFirstTime) {
      yield UnInitialized();
    }
    final User user = _service.getUser();

    if (user == null) {
      yield LoginFormState();
      return;
    }
    yield Authenticated(user: user);
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    await _service.signOut();
    yield UnAuthenticated();
  }

  Stream<AuthenticationState> _mapLoginWithGoogleEvent() async* {
    final LoginFormState currentState = tryCast<LoginFormState>(state) ?? LoginFormState();

    try {
      yield currentState.copyWith(isBusy: true);
      final UserCredential credential = await _service.googleSignIn();
      if (credential != null)
        yield Authenticated(user: User.fromFirebaseUser(credential.user));
      else
        yield currentState.copyWith(isBusy: false, formError: 'Google sign in fails!');
    } on CustomException catch (e) {
      yield currentState.copyWith(formError: e.cause);
    }
  }

  Stream<AuthenticationState> _mapLoginWithFaceBookPressedToState() async* {
    final LoginFormState currentState = tryCast<LoginFormState>(state) ?? LoginFormState();

    try {
      yield currentState.copyWith(isBusy: true);
      final UserCredential credential = await _service.facebookSignIn();
      if (credential != null)
        yield Authenticated(user: User.fromFirebaseUser(credential.user));
      else
        yield currentState.copyWith(isBusy: false, formError: 'Facebook sign in failed!');
    } on CustomException catch (e) {
      yield currentState.copyWith(isBusy: false, formError: e.cause);
    }
  }

  Stream<AuthenticationState> _mapLoginWithEmailPassEvent(LoginWithEmailPasswordPressed event) async* {
    final LoginFormState currentState =
        tryCast<LoginFormState>(state)?.copyWith(email: event.email, password: event.password) ??
            LoginFormState(email: event.email, password: event.password);

    try {
      if (_validators.validateEmail(value: currentState.email).isNotEmpty) {
        yield currentState.copyWith(formError: 'Incorrect email or password!');
        return;
      }
      yield currentState.copyWith(isBusy: true);

      final UserCredential credential = await _service.verifyUser(currentState.email, currentState.password);
      if (credential == null) {
        yield currentState.copyWith(isBusy: false, formError: 'Something went wrong, please try again');
        return;
      }
      yield currentState.copyWith(isBusy: false, formError: '');
      yield Authenticated();
    } on CustomException catch (_) {
      yield currentState.copyWith(isBusy: false, formError: 'Account not found!');
    }
  }

  Stream<AuthenticationState> _mapRegisterUserToState(
    SubmitRegistrationPressed event,
  ) async* {
    final RegisterFormState currentState = tryCast<RegisterFormState>(state) ?? RegisterFormState();

    try {
      final passwordError = _validators.validatePassword(value: event.password);
      final emailError = _validators.validateEmail(value: event.email);

      if (passwordError.isEmpty && emailError.isEmpty && event.phonenumber.length == 11) {
        yield currentState.copyWith(isBusy: true);
        final UserCredential credential = await _service.registerUser(
          event.email,
          event.password,
          event.fullname,
          event.phonenumber,
        );
        if (credential != null)
          yield Authenticated();
        else
          yield currentState.copyWith(isBusy: false, formError: 'Something went wrong, please try again');
      } else {
        yield currentState.copyWith(
          isBusy: false,
          passwordError: passwordError,
          emailError: emailError,
          formError: '',
        );
      }
    } on CustomException catch (e) {
      yield currentState.copyWith(isBusy: false, formError: e.cause);
    }
  }

  // ignore: unused_element
  Stream<AuthenticationState> _mapForgotPassword(String email) async* {
    final RegisterFormState currentState = tryCast<RegisterFormState>(state) ?? RegisterFormState();

    try {
      yield Loading();
      await _service.forgotPassword(email);
      yield Successful();
    } on CustomException catch (e) {
      yield currentState.copyWith(isBusy: false, formError: e.cause);
    }
  }

  Stream<AuthenticationState> _mapOnBoardingCompletedToState() async* {
    await Repository.getInstance().onBoardingCompleted();
    yield UnAuthenticated();
  }
}
