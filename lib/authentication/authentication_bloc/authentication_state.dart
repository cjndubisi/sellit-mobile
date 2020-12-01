part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => <Object>[];
}

class AuthenticationInitial extends AuthenticationState {}

class UnInitialized extends AuthenticationState {}

class UnAuthenticated extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  const Authenticated({this.user});
  final User user;
}

class Loading extends AuthenticationState {}

class Successful extends AuthenticationState {}

class Failed extends AuthenticationState {
  const Failed({@required this.message});

  final String message;

  @override
  List<Object> get props => <Object>[message];
}
