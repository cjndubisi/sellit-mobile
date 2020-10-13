part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}

class LoginWithGooglePressed extends AuthenticationEvent {}

class LoginWithFaceBookPressed extends AuthenticationEvent {}

class LoginWithEmailPasswordPressed extends AuthenticationEvent {
  LoginWithEmailPasswordPressed({this.email, this.password});
  final String email;
  final String password;
}

class SubmitRegistrationPressed extends AuthenticationEvent {
  SubmitRegistrationPressed({this.email, this.fullname, this.phonenumber, this.password});

  final String email;
  final String fullname;
  final String phonenumber;
  final String password;
}
