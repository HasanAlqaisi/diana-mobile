import 'package:chips_choice/chips_choice.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/quick_add_field.dart';
import 'package:diana/presentation/task/widgets/tags_chips.dart';
import 'package:diana/presentation/task/widgets/inbox/all_tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:diana/injection_container.dart' as di;

class InboxTaskTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // physics: NeverScrollableScrollPhysics(),
      children: [
        StreamBuilder<List<TagData>>(
            stream: TaskController.to.watchAllTags(),
            initialData: [],
            builder: (context, snapshot) {
              final data = snapshot?.data;
              if (data != null && data.isNotEmpty) {
                return Obx(() => ChipsChoice<String>.multiple(
                      // choiceStyle: C2ChoiceStyle(color: Colors.red),
                      // value is list of clicked tags (with mark on it)
                      value: TaskController.to.tags(),
                      // onChanged will generate a list with selected tags, u need to assign it
                      // to the value above
                      onChanged: (tags) =>
                          TaskController.to.tags.assignAll(tags),
                      choiceItems: C2Choice.listFrom<String, String>(
                        // All tags
                        source: data.map((tag) => tag.name).toList(),
                        value: (i, v) => v,
                        label: (i, v) => v,
                      ),
                    ));
              } else {
                print('TAGS UI: data is empty ${data?.isEmpty}');
                return Container();
              }
            }),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: QuickAddField(
            hint: 'Quick Task',
            onSubmitted: (taskName) {
              TaskController.to
                  .addTask(taskName, null, null, [], [], null, null, 0, false);
            },
          ),
        ),
        AllTasksList(),
      ],
    );
  }
}
