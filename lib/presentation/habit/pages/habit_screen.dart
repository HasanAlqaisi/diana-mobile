import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/pages/tabs/all_habits_tab.dart';
import 'package:diana/presentation/habit/pages/tabs/today_habits_tab.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/pages/tabs/inbox_task_tab.dart';
import 'package:diana/presentation/task/pages/tabs/today_task_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:diana/injection_container.dart' as di;

class HabitScreen extends StatelessWidget {
  static const route = '/habit';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0), //Not working
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: 'Hey, ',
                      style: TextStyle(fontWeight: FontWeight.w300)),
                  TextSpan(text: 'Hasan! '),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularStepProgressIndicator(
                totalSteps: 100,
                currentStep: 50,
                selectedColor: Color(0xFF00FFEF),
                unselectedColor: Colors.white,
                padding: 0,
                width: 40,
                stepSize: 3,
                child: CircleAvatar(
                  radius: 45,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg',
                    ),
                  ),
                ),
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
        body: GetBuilder<HabitController>(
          init: di.sl<HabitController>(),
          initState: (_) {},
          builder: (_) {
            return TabBarView(
              children: [
                TodayHabitsTab(),
                AllHabitsTab(),
              ],
            );
          },
        ),
      ),
    );
  }
}
