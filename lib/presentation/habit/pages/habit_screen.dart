import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/core/global_widgets/user_progress_image.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/pages/tabs/all_habits_tab.dart';
import 'package:diana/presentation/habit/pages/tabs/today_habits_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
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
                      appBar: AppBar(
                        title: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0), //Not working
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Hey, ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w300)),
                                TextSpan(text: '${user?.firstName ?? ''}'),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: _.onProfileImageTapped,
                              child: UserProgressImage(user: user),
                            ),
                          )
                        ],
                        bottom: TabBar(
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
                      )),
                );
              });
        });
  }
}
