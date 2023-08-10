import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(secondary: Colors.black),

);

final lightTheme = ThemeData(
  primaryColor: Color(0xFF202328),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: Color(0xFF651FFF))
      .copyWith(background: Color(0xFF12171D)),
);
