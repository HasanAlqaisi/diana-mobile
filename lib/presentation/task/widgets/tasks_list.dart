import 'package:diana/core/constants/enums.dart';
import 'package:flutter/widgets.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'expandable_task_item..dart';

class TasksList extends StatelessWidget {
  final TaskType type;

  const TasksList({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TaskController.to;
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
                      child: PhysicalModel(
                        elevation: 0.8,
                        color: type == TaskType.done
                            ? Color(0xFF1ADACE)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          decoration: type == TaskType.missed
                              ? BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Color(0xFFEAAE13)),
                                  borderRadius: BorderRadius.circular(15.0),
                                  // border: Border.all(color: Colors.grey, width: 0.5)
                                )
                              : null,
                          child: StreamBuilder<TaskWithTags>(
                            stream: controller
                                .watchTagsForTask(data[index].task.id),
                            builder: (context, taskWithTagsSnapshot) {
                              return ExpandableTaskItem(
                                  taskWithSubtasks: data[index],
                                  taskWithTags: taskWithTagsSnapshot?.data,
                                  type: type);
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
}
