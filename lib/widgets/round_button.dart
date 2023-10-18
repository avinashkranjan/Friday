import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {required this.color,
      required this.onPressed,
      required this.text,
      required this.textColor});
  final Color color;
  final String text;
  final VoidCallback onPressed;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(30)),
      ),
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
