import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/presentation/habit/pages/habit_screen.dart';
import 'package:diana/presentation/task/pages/add_task_screen.dart';
import 'package:diana/presentation/task/pages/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Nav extends StatefulWidget {
  static const String route = '/nav';

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  PersistentTabController _navController;
  List<Widget> navigationWidgets = [
    TaskScreen(),
    Container(),
    HabitScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _navController = PersistentTabController();
  }

  @override
  void dispose() {
    super.dispose();
    _navController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: PersistentTabView(
          context,
          controller: _navController,
          screens: navigationWidgets,
          items: _buildItems(),
          hideNavigationBarWhenKeyboardShows: true,
          handleAndroidBackButtonPress: true,
          backgroundColor: Color(0xFF6504C2),
          decoration: NavBarDecoration(
              borderRadius:
                  BorderRadius.circular(0.0)), //To avoid topRight null error
          navBarStyle: NavBarStyle.style15,

          onItemSelected: (index) {
            //TODO: Customize an algo to check the previous tab
            if (index == 1) {
              Navigator.pushNamed(context, AddTaskScreen.route);
            }
          },
          // body: navigationWidgets[_currentIndex],
        ),
      ),
    );
  }

  List<PersistentBottomNavBarItem> _buildItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_outlined),
        title: 'Tasks',
        activeColor: Colors.white,
        inactiveColor: Colors.black38,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.add),
        activeColor: Color(0xFF612EF3),
        activeColorAlternate: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.apps_outlined),
        title: 'Habits',
        activeColor: Colors.white,
        inactiveColor: Colors.black38,
      ),
    ];
  }
}
