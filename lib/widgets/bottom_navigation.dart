import 'package:class_manager/utils/bottom_navbar_tabs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Project Imports
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
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
  ProfileScreen _profileScreen;
  final PageController _pageController = PageController(initialPage: 0);

  _setCurrentPage({@required int index}) {
    setState(() {
      _selectedTab = index;
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
    _profileScreen = ProfileScreen();
    _pages = [
      _homeScreen,
      _classesScreen,
      _homeworkScreen,
      _homeworkScreen, //TODO: Chats Page
      _profileScreen,
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
    final navBar = Provider.of<BottomNavigationBarProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
            selectedTab: navBar.currentIndex,
            onPressed: (int idx) {
              _setCurrentPage(index: idx);
              _currentPage = _pages[idx];
              print(_selectedTab);
              // _selectedTab = idx;
            },
          )
        ],
      ),
    );
  }

  // bottomNavigator() {
  //   return Positioned(
  //     bottom: 0.0,
  //     left: 0.0,
  //     right: 0.0,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).backgroundColor,
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(30.0),
  //           topRight: Radius.circular(30.0),
  //         ),
  //       ),
  //       padding: EdgeInsets.symmetric(
  //         vertical: 10,
  //       ),
  //       child: Column(
  //         children: [
  //           BottomNavBar(
  //             selectedIdx: _selectedTab,
  //             selectedColor: Colors.white,
  //             unselectedColor: Colors.grey,
  //             itemPadding: EdgeInsets.all(10),
  //             onPressed: (int idx) {
  //               setState(() {
  //                 // _selectedTab = idx;
  //                 _setCurrentPage(index: idx);

  //                 _currentPage = _pages[idx];
  //                 _pageController.jumpToPage(idx);
  //                 print(_selectedTab);
  //               });
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class CustomBottomNavigator extends StatelessWidget {
  final int selectedTab;
  final void Function(int) onPressed;
  CustomBottomNavigator({
    @required this.selectedTab,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
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
