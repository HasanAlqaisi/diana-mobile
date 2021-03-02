import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/done/done_subtasks_list.dart';
import 'package:diana/presentation/task/widgets/general_subtasks_list.dart';
import 'package:diana/presentation/task/widgets/tags_row.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class DoneTasksList extends StatelessWidget {
  const DoneTasksList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskWithSubtasks>>(
        stream: TaskController.to.watchCompletedTasks(),
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
                        child: StreamBuilder<TaskWithTags>(
                          stream: TaskController.to
                              .watchTagsForTask(data[index].task.id),
                          builder: (context, taskWithTagsSnapshot) {
                            return Obx(
                              () => ListTileTheme(
                                tileColor: Color(0xFF1ADACE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ExpansionTile(
                                  title: Text(
                                    data[index].task.name,
                                    style: TextStyle(
                                      color: Color(0xFFA8FFF9),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  subtitle: Visibility(
                                      child: Text(
                                        data[index].task.note ?? '',
                                        style: TextStyle(
                                          color: Color(0xFFA8FFF9),
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      visible: data[index]?.task?.note != null
                                          ? true
                                          : false),
                                  trailing: _buildTrailing(
                                      data[index], taskWithTagsSnapshot?.data),
                                  tilePadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                  onExpansionChanged: (isExpanded) {
                                    TaskController.to.isLongPressed.value =
                                        false;

                                    if (isExpanded) {
                                      print('tapped to Expanded');
                                      TaskController.to.selectedTask.value =
                                          data[index].task.id;
                                    } else {
                                      print('tapped to close');
                                      TaskController.to.selectedTask.value = '';
                                    }
                                  },
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 0.0),
                                      child: DoneSubtasksList(
                                          taskWithSubtasks: data[index]),
                                    ),
                                    TagsRow(
                                        taskWithTags:
                                            taskWithTagsSnapshot?.data),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
            );
          } else {
            print('TASK UI: data is empty? ${data?.isEmpty}');
            return Container();
          }
        });
  }

  Widget _buildTrailing(TaskWithSubtasks taskData, TaskWithTags tagsData) {
    final selectedTask = TaskController.to.selectedTask.value;
    if (selectedTask == taskData.task.id) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                TaskController.to.onDeleteTaskClicked(taskData.task.id);
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
          // Icon(Icons.priority_high),
          SizedBox(width: 5),
          GestureDetector(
              onTap: () {
                print('check mark cliked');
                TaskController.to.makeTaskDone(taskData.task.id);
              },
              child: Icon(Icons.check_circle, color: Colors.white, size: 30.0)),
        ],
      );
    }
  }
}
