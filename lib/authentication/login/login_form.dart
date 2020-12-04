import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _email;

  String _password;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  AuthenticationBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  void attemptLogin() {
    final FormState form = _form.currentState;
    if (form.validate()) {
      form.save();
      _loginBloc.add(LoginWithEmailPasswordPressed(email: _email, password: _password));
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

        if (state is Failed) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Center(
              child: Column(
                children: const [
                  Text('Login Error'),
                  Text('Something went wrong please try again'),
                ],
              ),
            ),
          ));
        }
      },
      builder: (context, state) {
        return Scaffold(
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
                      style: style.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Sizing.small,
                    Text(
                      "Enter your email address and password to proceed. If you don't have an account, kindly register now",
                      style: style.copyWith(fontSize: 11, color: Colors.grey),
                    ),
                    Sizing.fab,
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Enter email address', prefixIcon: Icon(Icons.mail)),
                      onChanged: (String value) => _email = value.trim(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (String value) => value.isEmpty ? 'Email address can\'t be empty' : null,
                    ),
                    Sizing.fab,
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Enter password', prefixIcon: Icon(Icons.lock)),
                      onSaved: (String value) => _password = value.trim(),
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      validator: (String value) => value.isEmpty ? 'Password can\'t be empty' : null,
                    ),
                    Sizing.fab,
                    FlatButton(
                        onPressed: () => _navigationService.navigateTo('/forgot_password'),
                        child: Text(
                          'Forgot password?',
                          style: style.copyWith(decoration: TextDecoration.underline, color: ColorPalette.blue),
                        )),
                    Sizing.fab,
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: ColorPalette.primary,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        onPressed: () => attemptLogin(),
                        child: Text(
                          'Login',
                          textAlign: TextAlign.center,
                          style: style.copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                    Sizing.fab,
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Don't have an account?",
                            style: style.copyWith(color: Colors.grey),
                          ),
                          FlatButton(
                              onPressed: () => _navigationService.navigateTo('/register'),
                              child: Text(
                                'Register',
                                style:
                                    style.copyWith(decoration: TextDecoration.underline, color: ColorPalette.primary),
                              ))
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
                              onTap: () => _loginBloc.add(LoginWithFacebookPressed()),
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
                                        style: style.copyWith(color: Colors.blueAccent, fontWeight: FontWeight.bold),
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
                              onTap: () => _loginBloc.add(LoginWithGooglePressed()),
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
                                        style: style.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold),
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
