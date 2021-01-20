import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/form_widgets.dart';
import 'package:flutter_starterkit_firebase/core/navigation_service.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterForm createState() => _RegisterForm();
}

class _RegisterForm extends State<RegisterForm> {
  AuthenticationBloc _registerBLoc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _registerBLoc = BlocProvider.of<AuthenticationBloc>(context);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _fullName;

  RegisterFormState get formState => tryCast<RegisterFormState>(_registerBLoc.state);

  @override
  Widget build(BuildContext context) {
    final NavigationService _navService = context.watch<NavigationService>();

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        if (state is Authenticated) {
          _navService.setRootRoute('/dashboard');
        }
        if (state is RegisterFormState) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text(state.formError),
            ),
          );
        }
      },
      builder: (context, state) => Scaffold(
        key: _scaffoldKey,
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
                  // Email textfield
                  CustomTextField(
                    obscureText: false,
                    icon: Icon(Icons.email),
                    value: tryCast<LoginFormState>(state)?.email ?? '',
                    action: (value) => context
                        .read<AuthenticationBloc>()
                        .add(LoginFormValueChangedEvent(email: value.trim(), password: formState.password)),
                    helpTextValue: 'A complete, valid email e.g. joe@gmail.com',
                    hintTextValue: 'Email',
                    errorText:
                        (state as LoginFormState).emailError.isEmpty ? null : (state as LoginFormState).emailError,
                  ),

                  Sizing.medium,
                  Text(
                    'Phone Number',
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Sizing.small,
                  CustomTextField(
                    value: '',
                    action: (value) => context.read<AuthenticationBloc>().add(RegisterFormValueChangedEvent(
                          password: formState?.password ?? '',
                          email: formState?.email ?? '',
                          phoneNumber: value.trim(),
                        )),
                    hintTextValue: '',
                    helpTextValue: 'email',
                  ),

                  Sizing.medium,
                  Text(
                    'Full Name',
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Sizing.small,
                  CustomTextField(
                    hintTextValue: 'Name',
                    value: _fullName,
                    action: (value) {
                      _fullName = value.trim();
                    },
                    icon: Icon(Icons.portrait_rounded),
                    helpTextValue: 'full name',
                  ),

                  Sizing.fab,
                  Text(
                    'Password',
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Sizing.small,
                  CustomTextField(
                    obscureText: true,
                    icon: Icon(Icons.lock),
                    value: tryCast<LoginFormState>(state)?.password ?? '',
                    action: (value) => context
                        .read<AuthenticationBloc>()
                        .add(LoginFormValueChangedEvent(email: value.trim(), password: formState.password)),
                    helpTextValue: '''Password should be at least 8 characters with at least one letter and number''',
                    hintTextValue: 'Password',
                  ),
                  Sizing.fab,
                  SubmitButton(action: attemptRegister, label: 'register')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void attemptRegister() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerBLoc.add(SubmitRegistrationPressed(
        email: formState?.email ?? '',
        fullname: _fullName,
        phonenumber: formState?.phoneNumber ?? '',
        password: formState?.password,
      ));
    }
  }
}
