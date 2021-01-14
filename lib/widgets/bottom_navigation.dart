import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:class_manager/constants.dart';
import 'package:class_manager/screens/classes_screen.dart';
import 'package:class_manager/screens/home_screen.dart';
import 'package:class_manager/screens/homework_screen.dart';

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
    _pages = [_homeScreen, _classesScreen, _homeworkScreen];
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
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).backgroundColor,
          currentIndex: _selectedTab,
          onTap: (int index) {
            setState(() {
              _selectedTab = index;
              if (index == 0 || index == 1 || index == 2)
                _currentPage = _pages[index];
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/house.svg",
                width: 35.0,
                color: _selectedTab == 0
                    ? Theme.of(context).accentColor
                    : kTextColor,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/read_book.svg",
                width: 35.0,
                color: _selectedTab == 1
                    ? Theme.of(context).accentColor
                    : kTextColor,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/homework.svg",
                width: 35.0,
                color: _selectedTab == 2
                    ? Theme.of(context).accentColor
                    : kTextColor,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/test.svg",
                width: 35.0,
                color: _selectedTab == 3
                    ? Theme.of(context).accentColor
                    : kTextColor,
              ),
              title: SizedBox.shrink(),
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/icons/user.svg",
                width: 35.0,
                color: _selectedTab == 4
                    ? Theme.of(context).accentColor
                    : kTextColor,
              ),
              title: SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
