import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/nav/nav_controller.dart';
import 'package:diana/presentation/nav/tabbar_material_widget.dart';
import 'package:diana/presentation/task/pages/add_task_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:diana/injection_container.dart' as di;
import 'package:get/route_manager.dart';
import '../habit/pages/add_habit_bottom_sheet.dart';

class Nav extends StatelessWidget {
  static const String route = '/nav';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavController>(
      init: di.sl<NavController>(),
      builder: (_) {
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: 0,
          ),
          body: _.navigationWidgets[_.index],
          bottomNavigationBar: TabBarMaterialWidget(
            passedIndex: _.index,
            onChangedTab: _.onChangedTab,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_.index == 0) {
                Get.toNamed(AddTaskScreen.route);
              } else if (_.index == 1) {
                await Get.bottomSheet(AddHabitBottomSheet(),
                    isDismissible: false);
                HabitController.to.clearHabitInfo();
              }
            },
            elevation: 0,
            highlightElevation: 0,
            child: Container(
              height: 60, // Specified to make the gradient fill the entire FAB
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _.fillGradient(_.index),
              ),
              child: Icon(Icons.add),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
