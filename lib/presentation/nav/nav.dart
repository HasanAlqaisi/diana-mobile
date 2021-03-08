import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/presentation/habit/pages/add_habit_screen.dart';
import 'package:diana/presentation/habit/pages/habit_screen.dart';
import 'package:diana/presentation/nav/tabbar_cupertino_widget.dart';
import 'package:diana/presentation/nav/tabbar_material_widget.dart';
import 'package:diana/presentation/profile/pages/profile_screen.dart';
import 'package:diana/presentation/task/pages/add_task_screen.dart';
import 'package:diana/presentation/task/pages/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter/cupertino.dart';

class Nav extends StatefulWidget {
  static const String route = '/nav';

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  int index = 0;
  // PersistentTabController _navController;
  // bool _shouldHideNavBar = false;
  List<Widget> navigationWidgets = [
    TaskScreen(),
    HabitScreen(),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _navController = PersistentTabController();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _navController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: navigationWidgets[index],
      bottomNavigationBar: TabBarMaterialWidget(
        index: index,
        onChangedTab: onChangedTab,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (index == 0) {
            Get.toNamed(AddTaskScreen.route);
          } else if (index == 1) {
            Get.toNamed(AddHabitScreen.route);
          }
        },
        elevation: 0,
        highlightElevation: 0,
        child: Container(
          height: 60, // Specified to make the gradient fill the entire FAB
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _fillGradient(index),
          ),
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void onChangedTab(int index) {
    setState(() {
      this.index = index;
    });
  }

  LinearGradient _fillGradient(int index) {
    return index == 0
        ? LinearGradient(
            colors: [
              Color(0xFF492EF3),
              Color(0xFF852EF3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : LinearGradient(
            colors: [
              Color(0xFF00A3FF),
              Color(0xFF612EF3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );
  }

  // List<PersistentBottomNavBarItem> _buildItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon: Icon(Icons.home_outlined),
  //       title: 'Tasks',
  //       activeColor: Colors.white,
  //       inactiveColor: Colors.black38,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Icon(Icons.add),
  //       activeColor: Color(0xFF612EF3),
  //       activeColorAlternate: Colors.white,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Icon(Icons.apps_outlined),
  //       title: 'Habits',
  //       activeColor: Colors.white,
  //       inactiveColor: Colors.black38,
  //     ),
  //   ];
  // }
}
