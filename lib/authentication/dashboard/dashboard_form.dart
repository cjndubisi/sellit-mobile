import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class DashBoardForm extends StatefulWidget {
  @override
  _DashBoardForm createState() => _DashBoardForm();
}

class _DashBoardForm extends State<DashBoardForm> {
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sellit',
          style: style.copyWith(color: colorWhite),
        ),
        centerTitle: false,
        actions: [
          FlatButton.icon(onPressed: () => attemptLogout(), icon: Icon(Icons.power_settings_new), label: Container())
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  void attemptLogout() {
    _authenticationBloc.add(LoggedOut());
  }
}
