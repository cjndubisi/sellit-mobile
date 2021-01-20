import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/form_widgets.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthenticationBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  void attemptLogin(LoginFormState state) {
    final FormState form = _form.currentState;
    if (form.validate()) {
      print('email: $state.email,password:$state.password');
      form.save();
      _loginBloc.add(LoginWithEmailPasswordPressed(email: state.email, password: state.password));
    }
  }

  @override
  Widget build(BuildContext context) {
    final NavigationService _navigationService = context.watch<NavigationService>();

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        if (state is Authenticated) {
          _navigationService.setRootRoute('/dashboard');
        }

        if (state is LoginFormState && state.formError.isNotEmpty) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(state.formError),
          ));
        }
      },
      builder: (context, state) {
        final LoginFormState formState = tryCast<LoginFormState>(state) ?? LoginFormState();

        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text(
              'Sellit',
              style: style,
            ),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: Spacing.fab,
              child: Form(
                key: _form,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Sizing.fab,
                    Sizing.fab,
                    Text(
                      'Login to continue',
                      style: style.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Sizing.small,
                    Text(
                      '''Enter your email address and password to proceed. 
                      If you don't have an account, kindly register now''',
                      style: style.copyWith(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                    Sizing.fab,
                    Text(
                      'Email',
                      style: style.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextField(
                      obscureText: false,
                      icon: Icon(
                        Icons.email,
                      ),
                      value: tryCast<LoginFormState>(state)?.email ?? '',
                      action: (value) => context.read<AuthenticationBloc>().add(
                            LoginFormValueChangedEvent(email: value.trim(), password: formState.password),
                          ),
                      helpTextValue: 'A complete, valid email e.g. joe@gmail.com',
                      hintTextValue: 'Email',
                      errorText:
                          tryCast<LoginFormState>(state).email.isEmpty ? null : (state as LoginFormState).emailError,
                    ),
                    Sizing.fab,
                    Text(
                      'Password',
                      style: style.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomTextField(
                      obscureText: true,
                      icon: Icon(Icons.lock),
                      value: tryCast<LoginFormState>(state)?.password ?? '',
                      action: (value) => context.read<AuthenticationBloc>().add(
                            LoginFormValueChangedEvent(
                              email: formState.email,
                              password: value.trim(),
                            ),
                          ),
                      helpTextValue: '''Password should be at least 8 characters with at least one letter and number''',
                      hintTextValue: 'Password',
                      errorText: tryCast<LoginFormState>(state).password.isEmpty
                          ? null
                          : (state as LoginFormState).passwordError,
                    ),
                    Sizing.fab,
                    FlatButton(
                      onPressed: () => _navigationService.navigateTo('/forgot_password'),
                      child: Text(
                        'Forgot password?',
                        style: style.copyWith(
                          decoration: TextDecoration.underline,
                          color: ColorPalette.blue,
                        ),
                      ),
                    ),
                    Sizing.fab,
                    SubmitButton(
                      action: () => attemptLogin(
                        formState,
                      ),
                      label: 'login',
                    ),
                    Sizing.fab,
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: style.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => _navigationService.navigateTo('/register'),
                            child: Text(
                              'Register',
                              style: style.copyWith(
                                decoration: TextDecoration.underline,
                                color: ColorPalette.primary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Sizing.fab,
                    const Center(
                      child: Text(
                        'Or',
                        style: style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Sizing.fab,
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 45.0,
                            child: GestureDetector(
                              onTap: () => _loginBloc.add(
                                LoginWithFacebookPressed(),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorPalette.primary,
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                  ),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        'Facebook',
                                        style: style.copyWith(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 45.0,
                            child: GestureDetector(
                              onTap: () => _loginBloc.add(
                                LoginWithGooglePressed(),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorPalette.primary,
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                  ),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        'Google+',
                                        style: style.copyWith(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
