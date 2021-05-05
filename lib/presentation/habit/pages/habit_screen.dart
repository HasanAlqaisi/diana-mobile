import 'package:diana/core/constants/enums.dart';
import 'package:diana/core/global_widgets/diana_appbar.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/pages/tabs/habits_tab.dart';
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
      id: 'habit',
      builder: (_) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: buildDianaAppBar(
              user: _.user,
              tabBar: TabBar(
                tabs: [
                  SizedBox(height: 30, child: Text('Today')),
                  SizedBox(height: 30, child: Text('All')),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                HabitsTab(habitType: HabitType.today),
                HabitsTab(habitType: HabitType.inbox),
              ],
            ),
          ),
        );
      },
    );
  }
}
