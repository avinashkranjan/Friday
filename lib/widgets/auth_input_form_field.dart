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
  UnderlineInputBorder _inputBorderStyle = const UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white70,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      controller: widget.controller,
      obscureText: widget.obscureText,
      cursorColor: Colors.white,
      textInputAction: widget.textInputAction,
      style: TextStyle(color: Colors.white),
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
        hintStyle: kInputTextStyle,
        labelStyle: kInputTextStyle,
      ),
      validator: widget.validator,
    );
  }
}
