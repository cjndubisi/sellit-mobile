import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

import '../../main.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _email;

  String _password;

  GlobalKey<FormState> form = GlobalKey<FormState>();

  AuthenticationBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        if (state is Loading)
          await startLoading(context);
        else if (state is Successful) {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          loadingSuccessful(null);
        } else if (state is Failed) loadingFailed(state.message);
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: fabSpacing,
          child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                fabSize,
                fabSize,
                Text(
                  'Login to continue',
                  style: style.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                smallSize,
                Text(
                  "Enter your email address and password to proceed. If you don't have an account, kindly register now",
                  style: style.copyWith(fontSize: 11, color: colorGrey),
                ),
                fabSize,
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Enter email address', prefixIcon: Icon(Icons.mail)),
                  onChanged: (String value) => _email = value.trim(),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String value) => value.isEmpty ? 'Email address can\'t be empty' : null,
                ),
                fabSize,
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Enter password', prefixIcon: Icon(Icons.lock)),
                  onSaved: (String value) => _password = value.trim(),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (String value) => value.isEmpty ? 'Password can\'t be empty' : null,
                ),
                fabSize,
                FlatButton(
                    onPressed: () => navigateTo('/forgot_password', null, true),
                    child: Text(
                      'Forgot password?',
                      style: style.copyWith(decoration: TextDecoration.underline, color: colorBlue),
                    )),
                fabSize,
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: colorPrimary,
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
                fabSize,
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: style.copyWith(color: colorGrey),
                      ),
                      FlatButton(
                          onPressed: () => navigateTo('/register', null, true),
                          child: Text(
                            'Register',
                            style: style.copyWith(decoration: TextDecoration.underline, color: colorPrimary),
                          ))
                    ],
                  ),
                ),
                fabSize,
                Center(
                  child: Text(
                    'Or',
                    style: style,
                    textAlign: TextAlign.center,
                  ),
                ),
                fabSize,
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 45.0,
                        child: GestureDetector(
                          onTap: () => _loginBloc.add(LoginWithFaceBookPressed()),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorPrimary,
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
                                color: colorPrimary,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void attemptLogin() {
    final FormState current = form.currentState;
    if (current.validate()) {
      current.save();
      _loginBloc.add(LoginWithEmailPasswordPressed(email: _email, password: _password));
    }
  }
}
