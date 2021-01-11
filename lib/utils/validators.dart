import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/utils/constants.dart';

class Validators {
  factory Validators() => _validator;
  Validators._privateConstructor();
  static final Validators _validator = Validators._privateConstructor();

  String validatePassword({@required String value}) {
    const Pattern pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    final regex = RegExp(pattern.toString());
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return Strings.passwordValidationError;
    }
    return '';
  }

  String validateEmail({@required String value}) {
    const Pattern emailPatter =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final regex = RegExp(emailPatter.toString());

    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return Strings.emailInputError;
    }
    return '';
  }
}
