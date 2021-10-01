import 'package:flutter/material.dart';
import 'package:class_manager/constants.dart';

class AuthInputField extends StatefulWidget {
  final Widget suffixIcon;
  final bool obscureText;
  final String labelText, hintText;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String Function(String) validator;
  TextInputType textInputType;
  AuthInputField({
    this.textInputType = TextInputType.text,
    @required this.controller,
    @required this.labelText,
    this.obscureText = false,
    this.hintText,
    @required this.textInputAction,
    this.suffixIcon,
    @required this.validator,
  });
  @override
  _AuthInputFieldState createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder _inputBorderStyle = UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
    return TextFormField(
      keyboardType: widget.textInputType,
      controller: widget.controller,
      obscureText: widget.obscureText,
      cursorColor: Theme.of(context).colorScheme.primary,
      textInputAction: widget.textInputAction,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        suffixIcon: widget.suffixIcon,
        border: _inputBorderStyle,
        focusedBorder: _inputBorderStyle,
        enabledBorder: _inputBorderStyle,
        focusedErrorBorder: _inputBorderStyle,
        focusColor: Colors.white,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
      validator: widget.validator,
    );
  }
}
