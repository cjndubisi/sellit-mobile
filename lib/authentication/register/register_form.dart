import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterForm createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  AuthenticationBloc _registerBLoc;

  @override
  void initState() {
    super.initState();
    _registerBLoc = BlocProvider.of<AuthenticationBloc>(context);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email;

  String _phoneno;

  String _fullName;

  String _password;

  @override
  Widget build(BuildContext context) {
    final NavigationService _navService = context.watch<NavigationService>();
    final TextFormField emailText = TextFormField(
      onSaved: (String value) => _email = value.trim(),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: Spacing.medium,
        hintStyle: style,
        hintText: 'Email',
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
      maxLines: 1,
      validator: (String value) => value.isEmpty ? 'Email can\'t be empty' : null,
    );
    final phoneText = TextFormField(
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        counterText: '',
        contentPadding: Spacing.medium,
        hintStyle: style,
        hintText: 'Phone',
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
      maxLines: 1,
      maxLength: 11,
      onSaved: (String value) => _phoneno = value.trim(),
      validator: (String value) => value.isEmpty ? 'Phone can\'t be empty' : null,
    );
    final fullNameText = TextFormField(
      onSaved: (String value) => _fullName = value.trim(),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        counterText: '',
        contentPadding: Spacing.medium,
        hintStyle: style,
        hintText: 'Name',
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
      maxLines: 1,
      validator: (String value) => value.isEmpty ? 'Name can\'t be empty' : null,
    );
    final passwordText = TextFormField(
      onSaved: (String value) => _password = value.trim(),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: Spacing.medium,
        hintStyle: style,
        hintText: 'Password',
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      ),
      maxLines: 1,
      obscureText: true,
      validator: (String value) => value.isEmpty ? 'Password can\'t be empty' : null,
    );
    final registerBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: ColorPalette.primary,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => attemptRegister(),
        child: Text(
          'Register',
          textAlign: TextAlign.center,
          style: style.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    );
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        if (state is Authenticated) {
          _navService.setRootRoute('/dashboard');
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
            title: const Text('Registration'),
          ),
          body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Email Address',
                      style: style.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Sizing.small,
                    emailText,
                    Sizing.medium,
                    Text(
                      'Phone Number',
                      style: style.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Sizing.small,
                    phoneText,
                    Sizing.medium,
                    Text(
                      'Full Name',
                      style: style.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Sizing.small,
                    fullNameText,
                    Sizing.fab,
                    Text(
                      'Password',
                      style: style.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Sizing.small,
                    passwordText,
                    Sizing.fab,
                    if (state is Loading)
                      Row(
                        children: [
                          Spacer(),
                          CircularProgressIndicator(),
                          Spacer(),
                        ],
                      )
                    else
                      registerBtn
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void attemptRegister() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerBLoc.add(
          SubmitRegistrationPressed(email: _email, fullname: _fullName, phonenumber: _phoneno, password: _password));
    }
  }
}
