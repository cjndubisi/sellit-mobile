import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import '../../core/auth_service.dart';
import 'forgot_password_form.dart';




class ForgotPasswordScreen extends StatelessWidget {

  const ForgotPasswordScreen({Key key, @required AuthService service})
      : assert(service != null),
        _authService = service,
        super(key: key);

  final AuthService _authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AuthenticationBloc>(
        create: (_) => AuthenticationBloc(service: _authService),
        child: ForgotPasswordForm(),
      ),
    );
  }
}