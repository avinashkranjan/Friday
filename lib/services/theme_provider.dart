import 'package:flutter/material.dart';

import '../screens/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData? currentTheme;

  setLightMode() {
    currentTheme = lightTheme;
    notifyListeners();
  }

  setDarkmode() {
    currentTheme = darkTheme;
    notifyListeners();
  }
}
