import 'package:diana/presentation/habit/pages/add_habit_screen.dart';
import 'package:diana/presentation/habit/pages/habit_screen.dart';
import 'package:diana/presentation/task/pages/add_task_screen.dart';
import 'package:diana/presentation/task/pages/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class NavController extends GetxController {
  int index = 0;
  List<Widget> navigationWidgets = [
    TaskScreen(),
    HabitScreen(),
  ];

  void onChangedTab(int index) {
    this.index = index;
    update();
  }

  void onFABclicked() {
    if (index == 0) {
      Get.toNamed(AddTaskScreen.route);
    } else if (index == 1) {
      Get.toNamed(AddHabitScreen.route);
    }
  }

  LinearGradient fillGradient(int index) {
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
}
