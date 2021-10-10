import 'package:flutter/material.dart';

class Themes {
  ThemeData darkTheme() {
    return ThemeData(
      primaryColor: Color(0xFF202328),
      accentColor: Color(0xFF651FFF),
      backgroundColor: Colors.black87,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme.dark(
        primary: Colors.white,
        primaryVariant: Colors.white60,
        secondary: Colors.black38,
        surface: Color(0xFF6C7174),
        background: Color(0xFF12171D),
      ),
    );
  }

  ThemeData lightTheme() {
    return ThemeData(
      primaryColor: Color(0xFF202328),
      accentColor: Color(0xFF651FFF),
      backgroundColor: Colors.grey[350],
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme.light(
        primary: Colors.black87,
        primaryVariant: Colors.black45,
        secondary: Colors.white,
        surface: Colors.white70,
        background: Colors.white,
      ),
    );
  }
}
