import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/core/auth_service.dart';

import 'login/login_screen.dart';

@immutable
class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key key, @required AuthService service})
      : assert(service != null),
        _authService = service,
        super(key: key);

  final AuthService _authService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (_) => LoginScreen(service: _authService),
        '/login': (_) => LoginScreen(service: _authService),
      },
      initialRoute: '/',
    );
  }
}
