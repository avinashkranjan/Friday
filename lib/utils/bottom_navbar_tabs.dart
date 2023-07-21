import 'package:flutter/foundation.dart';

List<Map<String, String>> bottomNavBarData = const [

  {'svg': "assets/icons/house.svg", 'title': "Home"},
  {'svg': "assets/icons/read_book.svg", 'title': "Classes"},
  {'svg': "assets/icons/homework.svg", 'title': "Homework"},
  {'svg': "assets/icons/test.svg", 'title': "Alerts"},
  {'svg': "assets/icons/user.svg", 'title': "Profile"},
  {'svg': "assets/icons/settings.svg", 'title': "Settings"},


];

class BottomNavigationBarProvider extends ChangeNotifier {
  int currentIndex = 0;

  getCurrentIndex({required int index}) {
    currentIndex = index;
    notifyListeners();
  }

  resetCurrentIndex() {
    currentIndex = 0;
    notifyListeners();
  }
}
