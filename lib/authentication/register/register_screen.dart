import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_starterkit_firebase/authentication/register/register_form.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: RegisterForm(),
    );
  }
}
