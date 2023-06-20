import 'package:friday/utils/bottom_navbar_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Project Imports
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/classes_screen.dart';
import '../screens/homework_screen.dart';
import '../screens/alert_screen.dart';
import '../widgets/animated_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectedTab = 0;
  late Widget _currentPage;
  late List<Widget> _pages;
  late HomeScreen _homeScreen;
  late HomeworkScreen _homeworkScreen;
  late AlertScreen _alertScreen;
  late ClassesScreen _classesScreen;
  late ProfileScreen _profileScreen;
  final PageController _pageController = PageController(initialPage: 0);

  _setCurrentPage({required int index}) {
    setState(() {
      selectedTab = index;
      _pageController.jumpToPage(index);
      print('Widget rebuilt $index');
    });
  }

  @override
  void initState() {
    super.initState();
    _homeScreen = HomeScreen(
      openHomeworkPage: openHomeworkPage,
    );
    _classesScreen = ClassesScreen();
    _homeworkScreen = HomeworkScreen();
    _alertScreen = AlertScreen();
    _profileScreen = ProfileScreen();
    _pages = [
      _homeScreen,
      _classesScreen,
      _homeworkScreen,
      _alertScreen, //TODO: Chats Page
      _profileScreen,
    ];
    _currentPage = _homeScreen;
  }

  void openHomeworkPage() {
    setState(() {
      selectedTab = 2;
      _currentPage = _pages[2];
    });
  }

  @override
  Widget build(BuildContext context) {
    final navBar = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: <Widget>[
          PageView(
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int idx) {
              setState(() {
                // _selectedTab = idx;
                _setCurrentPage(index: idx);
                navBar.getCurrentIndex(index: idx);
                // print(_selectedTab);
                // _currentPage = _pages[idx];
              });
            },
            children: _pages,
          ),
          CustomBottomNavigator(
            // selectedTab: navBar.currentIndex,
            selectedTab: selectedTab,
            onPressed: (int idx) {
              _setCurrentPage(index: idx);
              _currentPage = _pages[idx];
              print(selectedTab);
              // _selectedTab = idx;
            },
          )
        ],
      ),
    );
  }
}

class CustomBottomNavigator extends StatelessWidget {
  final int selectedTab;
  final void Function(int) onPressed;
  CustomBottomNavigator({
    required this.selectedTab,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
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
              key: UniqueKey(),
              selectedIdx: selectedTab,
              selectedColor: Colors.white,
              unselectedColor: Colors.grey,
              itemPadding: EdgeInsets.all(10),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
