part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

class Uninitalized extends AuthenticationState {}

class Unauthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String displayName;

  Authenticated(this.displayName);

  @override
  List<Object> get props => [this.displayName];

  @override
  String toString() => 'Authenticated { displayName: $displayName }';
}
