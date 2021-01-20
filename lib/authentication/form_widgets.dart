import 'package:flutter/material.dart';
import 'package:flutter_starterkit_firebase/utils/resources.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({@required this.action, @required this.label});
  final Function action;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: ColorPalette.primary,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () => action(),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: style.copyWith(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    @required this.value,
    @required this.action,
    @required this.helpTextValue,
    this.icon,
    this.hintTextValue,
    this.obscureText = true,
    this.errorText,
  });
  final String value;
  final Function(String) action;
  final String helpTextValue;
  final String hintTextValue;
  final Icon icon;
  final bool obscureText;
  final String errorText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        hintText: hintTextValue,
        prefixIcon: icon,
        errorText: errorText,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
      keyboardType: TextInputType.text,
      obscureText: true,
      onChanged: (value) => action(value),
    );
  }
}
