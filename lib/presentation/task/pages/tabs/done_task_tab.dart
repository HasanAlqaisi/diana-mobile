import 'package:chips_choice/chips_choice.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/done/done_tasks_list.dart';
import 'package:diana/presentation/task/widgets/quick_add_field.dart';
import 'package:diana/presentation/task/widgets/tags_chips.dart';
import 'package:diana/presentation/task/widgets/inbox/all_tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:diana/injection_container.dart' as di;

class DoneTaskTab extends StatelessWidget {
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
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _buildChips(data),
                  ),
                );
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
        DoneTasksList(),
      ],
    );
  }

  List<Widget> _buildChips(List<TagData> tags) {
    List<Widget> chips = [];

    for (int i = 0; i < tags.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: TaskController.to.selectedTags.contains(i),
        label: Text(tags[i].name, style: TextStyle(color: Color(0xFF8E8E8E))),
        avatar: TaskController.to.selectedTags.contains(i)
            ? Icon(Icons.check, color: Color(0xFF8E8E8E))
            : null,
        pressElevation: 5,
        labelPadding: EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: Color(0xFFEDEDED),
        selectedColor: Colors.grey[300],
        onSelected: (bool isSelected) {
          TaskController.to.updateSelectedTags(index: i);
        },
      );
      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }
    return chips;
  }
}
