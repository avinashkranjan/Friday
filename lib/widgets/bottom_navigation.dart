import 'package:flutter/material.dart';

/// Project Imports
import '../screens/home_screen.dart';
import '../screens/classes_screen.dart';
import '../screens/homework_screen.dart';
import '../widgets/animated_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedTab = 0;
  Widget _currentPage;
  List<Widget> _pages;
  HomeScreen _homeScreen;
  HomeworkScreen _homeworkScreen;
  ClassesScreen _classesScreen;

  @override
  void initState() {
    super.initState();
    _homeScreen = HomeScreen(
      openHomeworkPage: openHomeworkPage,
    );
    _classesScreen = ClassesScreen();
    _homeworkScreen = HomeworkScreen();
    _pages = [
      _homeScreen,
      _classesScreen,
      _homeworkScreen,
      _homeworkScreen, //TODO: Chats Page
      _homeworkScreen, //TODO: Profile
    ];
    _currentPage = _homeScreen;
  }

  void openHomeworkPage() {
    setState(() {
      _selectedTab = 2;
      _currentPage = _pages[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          _currentPage,
          _bottomNavigator(),
        ],
      ),
    );
  }

  _bottomNavigator() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            BottomNavBar(
              selectedIdx: _selectedTab,
              selectedColor: Colors.white,
              unselectedColor: Colors.grey,
              itemPadding: EdgeInsets.all(10),
              onPressed: (int idx) {
                setState(() {
                  _selectedTab = idx;
                  _currentPage = _pages[idx];
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
