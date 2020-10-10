import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'authentication/authentication_bloc/authentication_bloc.dart';
import 'authentication/login/login_screen.dart';
import 'authentication/onboarding/onboarding_screen.dart';
import 'core/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      create: (_) => AuthenticationBloc(service: _authService)..add(AppStarted()),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        title: 'SellIt',
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (BuildContext context, AuthenticationState state) {
            switch (state.runtimeType) {
              case UnInitialized:
                return WelcomeActivity();
              case UnAuthenticated:
                return LoginScreen(
                  service: _authService,
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
        routes: {
          '/login': (BuildContext context) => LoginScreen(service: _authService),
        },
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

Future<void> startLoading(BuildContext context, [String message = 'Please wait...']) async {
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
    _progressDialog.hide().then((bool isHidden) {
      if (message != null) {
        if (showDialog)
          showMessageWithDialog(message, context, btnClicked);
        else
          toastSuccess(message);
      }
    });
}

void showMessageWithDialog(String message, BuildContext context, [VoidCallback btnClicked]) {
  showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
          title: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              const Icon(
                Icons.info,
                color: colorPrimary,
              ),
              const VerticalDivider(),
              const Text(
                'Message',
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
                'Okay',
                style: style.copyWith(color: colorWhite),
              ),
              color: colorPrimary,
            )
          ],
        );
      });
}

Future<void> loadingFailed(String message) async {
  if (_progressDialog != null)
    await _progressDialog.hide();
  if (message != null)
    toastError(message);
}

void toastSuccess(String message) {
  Fluttertoast.showToast(
      msg: message ?? '',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white);
}

void toastInfo(String message) {
  Fluttertoast.showToast(
    msg: message ?? '',
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
  );
}

void toastError(String message) {
  Fluttertoast.showToast(
      msg: message ?? '',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}

void toastError(String message) {
  Fluttertoast.showToast(
      msg: message == null ? '' : message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}