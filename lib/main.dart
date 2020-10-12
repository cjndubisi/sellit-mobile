import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'authentication/auth_service.dart';
import 'authentication/authentication_bloc/authentication_bloc.dart';
import 'authentication/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthenticationBloc(service: _authService)..add(AppStarted()),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        title: 'SellIt',
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is Uninitalized) {
              return WelcomeActivity();
            }
            if (state is Authenticated) {
              //return ListingScreen();
            }
            return WelcomeActivity();
          },
        ),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<dynamic> navigateTo(String routeName, [dynamic request, bool addToBackStack = false]) {
  if (addToBackStack)
    return navigatorKey.currentState.pushNamed(routeName, arguments: request);
  else
    return navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, (r) => false, arguments: request);
}

ProgressDialog _progressDialog;

Future<void> startLoading(BuildContext context, [String message = "Please wait..."]) async {
  if (_progressDialog != null && _progressDialog.isShowing()) _progressDialog.hide();
  _progressDialog = ProgressDialog(
    context,
    isDismissible: false,
  );
  _progressDialog.update(message: message, progress: 100);
  await _progressDialog.show();
}

void updateLoading(BuildContext context, String message) {
  _progressDialog.update(message: message);
}

void loadingSuccessful(String message, [bool showDialog = false, BuildContext context, VoidCallback btnClicked]) {
  if (_progressDialog != null && _progressDialog.isShowing())
    _progressDialog.hide().then((isHidden) {
      if (message != null) {
        if (showDialog)
          showMessageWithDialog(message, context, btnClicked);
        else
          toastSuccess(message);
      }
    });
}

void showMessageWithDialog(String message, BuildContext context, [VoidCallback btnClicked]) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
          title: Row(
            children: <Widget>[
              Icon(
                Icons.info,
                color: colorPrimary,
              ),
              VerticalDivider(),
              Text(
                "Message",
                style: style,
              )
            ],
          ),
          content: Text(
            message,
            style: style,
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                if (btnClicked != null) btnClicked.call();
              },
              child: Text(
                "Okay",
                style: style.copyWith(color: colorWhite),
              ),
              color: colorPrimary,
            )
          ],
        );
      });
}

Future<void> loadingFailed(String message) async {
  if (_progressDialog != null) await _progressDialog.hide();
  if (message != null) toastError(message);
}

void toastSuccess(String message) {
  Fluttertoast.showToast(
      msg: message == null ? '' : message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white);
}

void toastInfo(String message) {
  Fluttertoast.showToast(
    msg: message == null ? '' : message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  );
}

void toastError(String message) {
  Fluttertoast.showToast(
      msg: message == null ? '' : message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}
