import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({@required this.action});
  final Function(String) action;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (prevState, state) =>
          prevState is LoginFormState && state is LoginFormState && state.email != prevState.email,
      builder: (context, state) {
        final LoginFormState formState = tryCast<LoginFormState>(state) ?? LoginFormState();

        return TextFormField(
          initialValue: formState.email,
          decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email),
              labelText: 'Email',
              helperText: formState.isValidEmail ? 'Looks Good' : 'A complete, valid email e.g. joe@gmail.com',
              errorText:
                  formState.emailError //ormState.isValidEmail ? 'Please ensure the email entered is valid' : null,
              ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            action(value);
          },
          textInputAction: TextInputAction.next,
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({@required this.action, @required this.label});
  final Function action;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: ColorPalette.primary,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => action(),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: style.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({@required this.value, @required this.action, @required this.hintTextValue, this.icon});
  final String value;
  final Function(String) action;
  final String hintTextValue;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        hintText: hintTextValue,
        prefixIcon: icon,
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      onChanged: (value) => action(value),
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({@required this.action});
  final Function(String) action;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      buildWhen: (prevState, state) =>
          prevState is LoginFormState && state is LoginFormState && state.password != prevState.password,
      builder: (context, state) {
        if (state is! LoginFormState) {
          return null;
        }

        final LoginFormState formState = state as LoginFormState;
        return TextFormField(
          initialValue: formState.password,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintStyle: style,
            prefixIcon: const Icon(Icons.lock),
            helperText: formState.isValidPassword
                ? 'Looks Good'
                : '''Password should be at least 8 characters with at least one letter and number''',
            helperMaxLines: 2,
            labelText: 'Password',
            errorMaxLines: 2,
            errorText: formState
                .passwordError, //? '''Password must be at least 8 characters and contain at least one letter and number''' //: null,
          ),
          obscureText: true,
          onChanged: (value) {
            action(value);
          },
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}
