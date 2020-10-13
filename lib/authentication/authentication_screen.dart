import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/authentication/register/register_screen.dart';
import 'package:flutter_starterkit_firebase/core/auth_service.dart';

import 'login/login_screen.dart';

@immutable
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({
    Key key,
    @required AuthService authService,
  })  : assert(authService != null),
        _authService = authService,
        super(key: key);

  final AuthService _authService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, Widget Function(BuildContext)>{
        '/': (_) => LoginScreen(service: _authService),
        '/login': (_) => LoginScreen(service: _authService),
        '/register': (_) => RegisterScreen(service: _authService),
      },
      initialRoute: '/',
    );
  }
}
