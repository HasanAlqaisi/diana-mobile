import 'package:diana/core/constants/enums.dart';
import 'package:diana/core/utils/progress_loader.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/pages/add_task_screen.dart';
import 'package:diana/presentation/task/widgets/priority_widget.dart';
import 'package:diana/presentation/task/widgets/subtasks_list.dart';
import 'package:diana/presentation/task/widgets/tags_row.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

class ExpandableTaskItem extends StatelessWidget {
  final TaskWithSubtasks taskWithSubtasks;
  final TaskWithTags? taskWithTags;
  final TaskType? type;

  final controller = TaskController.to;

  ExpandableTaskItem({
    Key? key,
    required this.taskWithSubtasks,
    required this.taskWithTags,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ExpansionTile(
        title: Text(
          taskWithSubtasks.task!.name,
          style: TextStyle(
              color: _colorNameAndNote(),
              decoration: type != TaskType.done
                  ? TextDecoration.none
                  : TextDecoration.lineThrough),
        ),
        // ignore: null_aware_in_condition
        subtitle: taskWithSubtasks.task?.note != null &&
                taskWithSubtasks.task!.note!.isNotEmpty
            ? Text(taskWithSubtasks.task!.note!,
                style: TextStyle(
                    color: _colorNameAndNote(),
                    decoration: type != TaskType.done
                        ? TextDecoration.none
                        : TextDecoration.lineThrough))
            : null,
        trailing: _buildTrailing(),
        childrenPadding: type != TaskType.done
            ? EdgeInsets.symmetric(horizontal: 16)
            : EdgeInsets.zero,
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        onExpansionChanged: (isExpanded) {
          if (isExpanded) {
            controller.selectedTask.value = taskWithSubtasks.task!.id;
          } else {
            controller.selectedTask.value = '';
          }
        },
        children: [
          SubtasksList(
            type: type,
            taskWithSubtasks: taskWithSubtasks,
          ),
          TagsRow(taskType: type, taskWithTags: taskWithTags),
        ],
      ),
    );
  }

  Color _colorNameAndNote() {
    if (type == TaskType.missed) {
      return Color(0xFFEAAE13);
    } else if (type == TaskType.done) {
      return Color(0xFFA8FFF9);
    } else {
      return Color(0xFF636363);
    }
  }

  Widget _buildTrailing() {
    final selectedTask = controller.selectedTask.value;

    if (selectedTask == taskWithSubtasks.task!.id) {
      return _buildSelectedTaskIcons();
    } else {
      return _buildUnselectedTaskIcons();
    }
  }

  Widget _buildUnselectedTaskIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (type != TaskType.done && type != TaskType.missed)
          PriorityWidget(
            priority: taskWithSubtasks.task?.priority,
            color: _priorityColor(taskWithSubtasks.task!),
          ),
        SizedBox(width: 5),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            highlightColor: Colors.transparent,
            icon: Icon(Icons.check_circle, color: _colorMarkIcon(), size: 30.0),
            onPressed: () async {
              showLoaderDialog();
              await controller.makeTaskDone(taskWithSubtasks.task!.id);
              Get.back();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedTaskIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(FontAwesomeIcons.trash, color: Colors.red),
          constraints: BoxConstraints(minWidth: 20, minHeight: 20),
          highlightColor: Colors.transparent,
          onPressed: () async {
            showLoaderDialog();
            await controller.onDeleteTaskClicked(taskWithSubtasks.task!.id);
            Get.back();
          },
        ),
        IconButton(
          icon: Icon(FontAwesomeIcons.pen),
          constraints: BoxConstraints(minWidth: 20, minHeight: 20),
          highlightColor: Colors.transparent,
          onPressed: () async {
            await Get.toNamed(
              AddTaskScreen.route,
              arguments: [taskWithSubtasks, taskWithTags],
            );
          },
        ),
      ],
    );
  }

  Color _colorMarkIcon() {
    if (type == TaskType.done) {
      return Colors.white;
    } else if (type == TaskType.missed) {
      return Color(0xFFEAAE13);
    } else {
      return Colors.grey;
    }
  }

  Color _priorityColor(TaskData taskData) {
    if (taskData.priority == 1) {
      return Colors.green;
    } else if (taskData.priority == 2) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
