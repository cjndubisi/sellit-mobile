import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sellit',
          style: style,
        ),
        elevation: 0,
      ),
      body: LoginForm(),
    );
  }
}
