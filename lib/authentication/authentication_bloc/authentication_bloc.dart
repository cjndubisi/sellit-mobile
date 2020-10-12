import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../auth_service.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService _service;

  AuthenticationBloc({@required AuthService service})
      : assert(service != null),
        _service = service,
        super(null);

  AuthenticationState get initialState => Uninitalized();

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
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    final isFirstTime = await _service.isFirstTime();

    if (isFirstTime) {
      yield Uninitalized();
      return;
    }

    final user = _service.getUser();

    if (user == null) {
      yield Unauthenticated();
      return;
    }

    yield Authenticated(user.email);
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    if (_service.isSignedIn()) {
      yield Authenticated(_service.getUser().email);
      return;
    }
    yield Unauthenticated();
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
  }
}
