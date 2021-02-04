import 'package:chips_choice/chips_choice.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/quick_add_field.dart';
import 'package:diana/presentation/task/widgets/tags_chips.dart';
import 'package:diana/presentation/task/widgets/tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:diana/injection_container.dart' as di;

class TodayTaskTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      init: di.sl<TaskController>(),
      builder: (controller) => ListView(
        // physics: NeverScrollableScrollPhysics(),
        children: [
          TagChips(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: QuickAddField(),
          ),
          TasksList(),
        ],
      ),
    );
  }
}