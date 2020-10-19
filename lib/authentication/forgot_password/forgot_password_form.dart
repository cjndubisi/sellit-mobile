import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:flutter_starterkit_firebase/utils/utility.dart';

class ForgotPasswordForm extends StatefulWidget {
  @override
  _ForgotPasswordForm createState() => _ForgotPasswordForm();
}

class _ForgotPasswordForm extends State<ForgotPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email;

  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final UtilityProvider _utilityProvider = context.repository<UtilityProvider>();
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
    final Material forgotPassBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: ColorPalette.primary,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => attemptForgotPassword(),
        child: Text(
          'Register',
          textAlign: TextAlign.center,
          style: style.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    );
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        if (state is Loading) {
          await _utilityProvider.startLoading(context);
        } else if (state is Successful) {
          _utilityProvider.loadingSuccessful(null);
        } else if (state is Failed) {
          _utilityProvider.loadingFailed(state.message);
        }
      },
      child: SingleChildScrollView(
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
                Sizing.medium,
                emailText,
                Sizing.medium,
                Sizing.fab,
                forgotPassBtn
              ],
            ),
          ),
        ),
      ),
    );
  }

  void attemptForgotPassword() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _authenticationBloc.add(ForgotPasswordPressed(email: _email));
    }
  }
}
