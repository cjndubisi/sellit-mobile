import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UtilityProvider {
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

  ProgressDialog _progressDialog;

  Future<void> startLoading(BuildContext context, [String message = 'Please wait...']) async {
    if (_progressDialog != null && _progressDialog.isShowing()) {
      _progressDialog.hide();
    }
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
                  color: ColorPalette.primary,
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
                  if (btnClicked != null) {
                    btnClicked.call();
                  }
                },
                child: Text(
                  'Okay',
                  style: style.copyWith(color: Colors.white),
                ),
                color: ColorPalette.primary,
              )
            ],
          );
        });
  }

  Future<void> loadingFailed(String message) async {
    if (_progressDialog != null) {
      await _progressDialog.hide();
    }
    if (message != null) {
      toastError(message);
    }
  }
}
