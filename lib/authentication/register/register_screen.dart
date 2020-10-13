import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/register/register_form.dart';

import '../../core/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key key, @required AuthService service})
      : assert(service != null),
        _authService = service,
        super(key: key);

  final AuthService _authService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: BlocProvider<AuthenticationBloc>(
        create: (_) => AuthenticationBloc(service: _authService),
        child: RegisterForm(),
      ),
    );
  }
}
