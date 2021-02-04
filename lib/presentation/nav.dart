import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/presentation/habit/pages/habit_screen.dart';
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0), //Not working
            child: Text(
              'Hey, Hasan',
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularStepProgressIndicator(
                totalSteps: 100,
                currentStep: 80,
                selectedColor: Colors.blue,
                unselectedColor: Colors.white,
                padding: 0,
                width: 40,
                stepSize: 7,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg',
                ),
              ),
            )
          ],
          bottom: TabBar(
            tabs: [
              SizedBox(height: 30, child: Text('Today')),
              SizedBox(height: 30, child: Text('Inbox')),
              SizedBox(height: 30, child: Text('Done')),
              SizedBox(height: 30, child: Text('Missed')),
            ],
          ),
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

            onItemSelected: (index) => {
              //TODO: Customize an algo to check the previous tab
              if (index == 1) print('Hi')
            },
            // body: navigationWidgets[_currentIndex],
          ),
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
