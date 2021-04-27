import 'package:diana/core/global_widgets/diana_appbar.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/pages/tabs/all_habits_tab.dart';
import 'package:diana/presentation/habit/pages/tabs/today_habits_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:diana/injection_container.dart' as di;

class HabitScreen extends StatelessWidget {
  static const route = '/habit';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HabitController>(
      init: di.sl<HabitController>(),
      builder: (_) {
        return StreamBuilder<UserData>(
          stream: _.watchUser(),
          builder: (context, userSnapshot) {
            final user = userSnapshot.data;
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: buildDianaAppBar(
                  user: user,
                  tabBar: TabBar(
                    tabs: [
                      SizedBox(height: 30, child: Text('Today')),
                      SizedBox(height: 30, child: Text('All')),
                    ],
                  ),
                ),
                body: TabBarView(
                  children: [
                    TodayHabitsTab(),
                    AllHabitsTab(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
