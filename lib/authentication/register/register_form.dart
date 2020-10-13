import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
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
    final TextFormField emailText = TextFormField(
      onSaved: (String value) => _email = value.trim(),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        fillColor: colorWhite,
        filled: true,
        contentPadding: mediumSpacing,
        hintStyle: style,
        hintText: 'Email',
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorGrey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorGrey)),
      ),
      maxLines: 1,
      validator: (String value) => value.isEmpty ? 'Email can\'t be empty' : null,
    );
    final TextFormField phoneText = TextFormField(
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        fillColor: colorWhite,
        filled: true,
        counterText: '',
        contentPadding: mediumSpacing,
        hintStyle: style,
        hintText: 'Phone',
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorGrey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorGrey)),
      ),
      maxLines: 1,
      maxLength: 11,
      onSaved: (String value) => _phoneno = value.trim(),
      validator: (String value) => value.isEmpty ? 'Phone can\'t be empty' : null,
    );
    final TextFormField fullNameText = TextFormField(
      onSaved: (String value) => _fullName = value.trim(),
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        fillColor: colorWhite,
        filled: true,
        counterText: '',
        contentPadding: mediumSpacing,
        hintStyle: style,
        hintText: 'Name',
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorGrey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorGrey)),
      ),
      maxLines: 1,
      validator: (String value) => value.isEmpty ? 'Name can\'t be empty' : null,
    );
    final TextFormField passwordText = TextFormField(
      onSaved: (String value) => _password = value.trim(),
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        fillColor: colorWhite,
        filled: true,
        contentPadding: mediumSpacing,
        hintStyle: style,
        hintText: 'Password',
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colorGrey)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colorGrey)),
      ),
      maxLines: 1,
      obscureText: true,
      validator: (String value) => value.isEmpty ? 'Password can\'t be empty' : null,
    );
    final Material registerBtn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: colorPrimary,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registration',
          style: style.copyWith(color: colorWhite),
        ),
        centerTitle: false,
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
                smallSize,
                emailText,
                mediumSize,
                Text(
                  'Phone Number',
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                smallSize,
                phoneText,
                mediumSize,
                Text(
                  'Full Name',
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                smallSize,
                fullNameText,
                fabSize,
                Text(
                  'Password',
                  style: style.copyWith(fontWeight: FontWeight.bold),
                ),
                smallSize,
                passwordText,
                fabSize,
                registerBtn
              ],
            ),
          ),
        ),
      ),
    );
  }

  void attemptRegister() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerBLoc.add(
          SubmitRegistrationPressed(email: _email, fullname: _fullName, phonenumber: _phoneno, password: _password));
    }
  }
}
