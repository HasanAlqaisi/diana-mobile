import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/subtasks_list.dart';
import 'package:diana/presentation/task/widgets/tags_row.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TaskWithSubtasks>>(
        stream: TaskController.to.watchAllTasks(),
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
                        child: Material(
                          elevation: 0.8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0),
                              // border: Border.all(color: Colors.grey, width: 0.5)
                            ),
                            child: StreamBuilder<TaskWithTags>(
                              stream: TaskController.to
                                  .watchTagsForTask(data[index].task.id),
                              builder: (context, taskWithTagsSnapshot) {
                                return Obx(
                                  () => ExpansionTile(
                                    title: Text(data[index].task.name),
                                    subtitle: Visibility(
                                        child: Text(data[index].task.note ?? '',
                                            style:
                                                TextStyle(color: Colors.grey)),
                                        visible: data[index]?.task?.note != null
                                            ? true
                                            : false),
                                    trailing: _buildTrailing(),
                                    backgroundColor: Colors.white,
                                    childrenPadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    tilePadding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    onExpansionChanged: (isExpanded) {
                                      if (isExpanded) {
                                        TaskController.to.isExpand.value =
                                            isExpanded;
                                        TaskController.to.isLongPressed.value =
                                            false;
                                        print('tapped to Expanded');
                                      } else {
                                        TaskController.to.isExpand.value =
                                            isExpanded;
                                        TaskController.to.isLongPressed.value =
                                            false;
                                        print('tapped to close');
                                      }
                                    },
                                    children: [
                                      SubtasksList(
                                          taskWithSubtasks: data[index]),
                                      TagsRow(
                                          taskWithTags:
                                              taskWithTagsSnapshot?.data),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
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

  Widget _buildTrailing() {
    final isExpand = TaskController.to.isExpand.value;
    if (!isExpand) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.priority_high),
          SizedBox(width: 10),
          Icon(Icons.check_outlined),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.trash, color: Colors.red),
          SizedBox(width: 10),
          Icon(FontAwesomeIcons.pencilAlt),
        ],
      );
    }
  }
}