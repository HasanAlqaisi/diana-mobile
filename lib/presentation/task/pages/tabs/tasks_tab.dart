import 'package:diana/core/constants/enums.dart';
import 'package:diana/core/date/date_helper.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/quick_add_field.dart';
import 'package:diana/presentation/task/widgets/tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TasksTab extends StatelessWidget {
  final TaskType type;

  const TasksTab({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TaskController.to;
    return ListView(
      children: [
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _buildChips(controller.tagsData),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
          child: QuickAddField(
            hint: 'Quick Task',
            textController: controller.textController,
            onSubmitted: (taskName) async {
              if (type == TaskType.inbox) {
                await controller.addTask(taskName);
              } else if (type == TaskType.today) {
                await controller.addTask(taskName,
                    date: DateHelper.getCurrentYYYYmmDD(DateTime.now()));
              }
              controller.textController.text = '';
            },
            errorText: controller.failure is TaskFieldsFailure
                ? (controller.failure as TaskFieldsFailure)?.name?.first
                : null,
          ),
        ),
        _buildTaskList(taskType: type),
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
          padding: i != tags.length - 1
              ? EdgeInsets.only(left: 16.0, top: 6.0)
              : EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0),
          child: choiceChip));
    }
    return chips;
  }

  Widget _buildTaskList({TaskType taskType}) {
    if (taskType == TaskType.today) {
      return TasksList(type: TaskType.today);
    } else if (taskType == TaskType.inbox) {
      return TasksList(type: TaskType.inbox);
    } else if (taskType == TaskType.done) {
      return TasksList(type: TaskType.done);
    } else if (taskType == TaskType.missed) {
      return TasksList(type: TaskType.missed);
    } else {
      return Container();
    }
  }
}
