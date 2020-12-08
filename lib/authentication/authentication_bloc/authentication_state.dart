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

class LoginFormState extends UnAuthenticated {
  LoginFormState({
    this.email = '',
    this.password = '',
    this.emailError = '',
    this.passwordError = '',
    this.isBusy = false,
    this.formError = '',
  }) : super();

  final String email; // email or phonenumber
  final String password;

  bool get isValidEmail => emailError.isEmpty;
  bool get isValidPassword => passwordError.isEmpty;

  final String emailError;
  final String passwordError;
  /// True is user can edit form.
  final bool isBusy;
  final String formError;

  @override
  List<Object> get props => <Object>[email, password, emailError, passwordError, formError, isBusy];

  LoginFormState copyWith({
    String email,
    String phoneNumber,
    String password,
    String emailError,
    String passwordError,
    bool isBusy,
    String formError,
  }) {
    return LoginFormState(
        email: email ?? this.email,
        password: password ?? this.password,
        emailError: emailError ?? this.emailError,
        passwordError: passwordError ?? this.passwordError,
        isBusy: isBusy ?? this.isBusy,
        formError: formError ?? this.formError);
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterFormState extends LoginFormState {
  RegisterFormState(
      {String email = '',
      this.phoneNumber = '',
      String password = '',
      String emailError = '',
      String passwordError = '',
      bool isBusy = false,
      String formError = ''})
      : super(
          email: email,
          password: password,
          emailError: emailError,
          passwordError: passwordError,
          isBusy: isBusy,
          formError: formError,
        );

  final String phoneNumber;

  @override
  RegisterFormState copyWith({
    String email,
    String phoneNumber,
    String password,
    String emailError,
    String passwordError,
    bool isBusy,
    String formError,
  }) {
    return RegisterFormState(
        email: email ?? this.email,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        password: password ?? this.password,
        emailError: emailError ?? this.emailError,
        passwordError: passwordError ?? this.passwordError,
        isBusy: isBusy ?? this.isBusy,
        formError: formError ?? this.formError);
  }
}
