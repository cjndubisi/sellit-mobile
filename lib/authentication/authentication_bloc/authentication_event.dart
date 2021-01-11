part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class OnBoardingCompleted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {}

class LogOutEvent extends AuthenticationEvent {}

class LoginWithGooglePressed extends AuthenticationEvent {}

class LoginWithFacebookPressed extends AuthenticationEvent {}

class LoginWithEmailPasswordPressed extends AuthenticationEvent {
  LoginWithEmailPasswordPressed({
    this.email,
    this.password,
  });
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password, DateTime.now().toString()];

  LoginWithEmailPasswordPressed copyWith({
    String email,
    String password,
  }) {
    return LoginWithEmailPasswordPressed(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() => 'LoginWithEmailPasswordPressed(email: $email, password: $password)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is LoginWithEmailPasswordPressed && other.email == email && other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}

class SubmitRegistrationPressed extends AuthenticationEvent {
  SubmitRegistrationPressed({
    this.email = '',
    this.fullname = '',
    this.phonenumber = '',
    this.password = '',
  });

  // TODO(cjndubisi): Remove values as they aren't needed due to ValueChangedEvent
  final String email;
  final String fullname;
  final String phonenumber;
  final String password;
}

class ForgotPasswordPressed extends AuthenticationEvent {
  ForgotPasswordPressed({this.email});
  final String email;
}

class LoginFormValueChangedEvent extends AuthenticationEvent {
  LoginFormValueChangedEvent({
    this.email,
    this.password,
  });

  final String email;
  final String password;

  LoginFormValueChangedEvent copyWith({
    String email,
    String phoneNumber,
    String password,
  }) {
    return LoginFormValueChangedEvent(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() => 'LoginFormValueChangedEvent(email: $email, password: $password)';
}

class RegisterFormValueChangedEvent extends LoginFormValueChangedEvent {
  RegisterFormValueChangedEvent({
    String email,
    this.phoneNumber,
    String password,
  }) : super(email: email, password: password);

  final String phoneNumber;

  @override
  RegisterFormValueChangedEvent copyWith({
    String email,
    String phoneNumber,
    String password,
  }) {
    return RegisterFormValueChangedEvent(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }

  @override
  String toString() => 'RegisterFormValueChangedEvent(email: $email, phoneNumber: $phoneNumber, password: $password)';
}
