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

    return BlocListener<AuthenticationBloc, AuthenticationState>(
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
      child: Scaffold(
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
                  EmailInput(
                    action: (value) {
                      context.read<AuthenticationBloc>().add(RegisterFormValueChangedEvent(
                            email: value.trim(),
                            password: formState?.phoneNumber ?? '',
                            phoneNumber: formState.phoneNumber,
                          ));
                    },
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
                      icon: Icon(Icons.portrait_rounded)),

                  Sizing.fab,
                  Text(
                    'Password',
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Sizing.small,
                  PasswordInput(
                    action: (value) => context.read<AuthenticationBloc>().add(RegisterFormValueChangedEvent(
                          password: value.trim(),
                          email: formState?.email ?? '',
                          phoneNumber: formState.phoneNumber,
                        )),
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
