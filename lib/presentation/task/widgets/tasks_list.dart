import 'package:diana/core/constants/enums.dart';
import 'package:flutter/widgets.dart';
import 'package:diana/core/utils/progress_loader.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/subtasks_list.dart';
import 'package:diana/presentation/task/widgets/tags_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TasksList extends StatelessWidget {
  final TaskType type;

  const TasksList({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskWithSubtasks>>(
        stream: _watch(),
        builder: (context, snapshot) {
          final data = snapshot?.data;
          if (data != null && data.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onLongPress: () {
                          print('long tapped!');
                          TaskController.to.isLongPressed.value = true;
                        },
                        child: PhysicalModel(
                          elevation: 1.8,
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              // border: Border.all(color: Colors.grey, width: 0.5)
                            ),
                            child: Container(
                              decoration: type == TaskType.missed
                                  ? BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Color(0xFFEAAE13)),
                                      borderRadius: BorderRadius.circular(15.0),
                                      // border: Border.all(color: Colors.grey, width: 0.5)
                                    )
                                  : null,
                              child: StreamBuilder<TaskWithTags>(
                                stream: TaskController.to
                                    .watchTagsForTask(data[index].task.id),
                                builder: (context, taskWithTagsSnapshot) {
                                  return Obx(
                                    () => ListTileTheme(
                                      tileColor: type != TaskType.done
                                          ? Colors.white
                                          : Color(0xFF1ADACE),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ExpansionTile(
                                        title: Text(
                                          data[index].task.name,
                                          style: TextStyle(
                                              color: _colorNameAndNote(),
                                              decoration: type != TaskType.done
                                                  ? TextDecoration.none
                                                  : TextDecoration.lineThrough),
                                        ),
                                        subtitle: Visibility(
                                            child: Text(
                                                data[index].task.note ?? '',
                                                style: TextStyle(
                                                    color: _colorNameAndNote(),
                                                    decoration: type !=
                                                            TaskType.done
                                                        ? TextDecoration.none
                                                        : TextDecoration
                                                            .lineThrough)),
                                            visible:
                                                data[index]?.task?.note != null
                                                    ? true
                                                    : false),
                                        trailing: _buildTrailing(
                                          taskData: data[index],
                                          tagsData: taskWithTagsSnapshot?.data,
                                          context: context,
                                        ),
                                        childrenPadding: type != TaskType.done
                                            ? EdgeInsets.symmetric(
                                                horizontal: 16)
                                            : EdgeInsets.zero,
                                        tilePadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        onExpansionChanged: (isExpanded) {
                                          TaskController
                                              .to.isLongPressed.value = false;

                                          if (isExpanded) {
                                            print('tapped to Expanded');
                                            TaskController.to.selectedTask
                                                .value = data[index].task.id;
                                          } else {
                                            print('tapped to close');
                                            TaskController
                                                .to.selectedTask.value = '';
                                          }
                                        },
                                        children: [
                                          SubtasksList(
                                            type: type,
                                            taskWithSubtasks: data[index],
                                          ),
                                          TagsRow(
                                              taskType: type,
                                              taskWithTags:
                                                  taskWithTagsSnapshot?.data),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          } else {
            return Container(
              height: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text("You don’t have any tasks",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFCACACA),
                        )),
                  ),
                  SvgPicture.asset('assets/tasks_holder.svg'),
                ],
              ),
            );
          }
        });
  }

  Stream<dynamic> _watch() {
    if (type == TaskType.today) {
      return TaskController.to.watchTodayTasks(TaskController.to.tags());
    } else if (type == TaskType.inbox) {
      return TaskController.to.watchAllTasks(TaskController.to.tags());
    } else if (type == TaskType.done) {
      return TaskController.to.watchCompletedTasks(TaskController.to.tags());
    } else if (type == TaskType.missed) {
      return TaskController.to.watchMissedTasks(TaskController.to.tags());
    } else {
      return null;
    }
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

  Widget _buildTrailing({
    TaskWithSubtasks taskData,
    TaskWithTags tagsData,
    BuildContext context,
  }) {
    final selectedTask = TaskController.to.selectedTask.value;
    if (selectedTask == taskData.task.id) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () async {
                showLoaderDialog();
                await TaskController.to.onDeleteTaskClicked(taskData.task.id);
                Navigator.pop(context);
              },
              child: Icon(FontAwesomeIcons.trash, color: Colors.red)),
          SizedBox(width: 10),
          Icon(FontAwesomeIcons.pencilAlt),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (type != TaskType.done && type != TaskType.missed)
            Row(
                children: List.generate(
              taskData.task.priority,
              (index) => Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: _priorityColor(taskData.task),
                      shape: BoxShape.circle,
                    ),
                  ),
                  index + 1 != taskData.task.priority
                      ? SizedBox(
                          width: 10,
                          child: Divider(
                            color: _priorityColor(taskData.task),
                            thickness: 1,
                          ))
                      : Container(),
                ],
              ),
            )),
          SizedBox(width: 5),
          GestureDetector(
              onTap: () async {
                showLoaderDialog();
                await TaskController.to.makeTaskDone(taskData.task.id);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child:
                    Icon(Icons.check_circle, color: _colorCircle(), size: 30.0),
              )),
        ],
      );
    }
  }

  Color _colorCircle() {
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
