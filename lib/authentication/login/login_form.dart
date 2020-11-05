import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';

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
    final UtilityProvider _utilityProvider = context.repository<UtilityProvider>();
    final NavigationService _navigationService = context.repository<NavigationService>();

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        if (state is Loading) {
          await _utilityProvider.startLoading(context);
        } else if (state is Successful) {
          _loginBloc.add(LoggedIn());
          _utilityProvider.loadingSuccessful(null);
        } else if (state is Failed)
          _utilityProvider.loadingFailed(state.message);
        else if (state is Authenticated) {
          _navigationService.navigateTo('/dashboard');
        }
      },
      child: SingleChildScrollView(
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
                    onPressed: () => _navigationService.setRootRoute('/forgot_password'),
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
                          onPressed: () => _navigationService.setRootRoute('/register'),
                          child: Text(
                            'Register',
                            style: style.copyWith(decoration: TextDecoration.underline, color: ColorPalette.primary),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
