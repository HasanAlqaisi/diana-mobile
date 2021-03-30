import 'package:diana/core/constants/enums.dart';
import 'package:diana/core/global_widgets/user_progress_image.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/pages/tabs/tasks_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:diana/injection_container.dart' as di;

class TaskScreen extends StatelessWidget {
  static const route = '/task';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
        init: di.sl<TaskController>(),
        builder: (_) {
          return StreamBuilder<UserData>(
            stream: _.watchUser(),
            builder: (context, userSnapshot) {
              // print('User stream called: ${userSnapshot.requireData}');
              final user = userSnapshot.data;
              return DefaultTabController(
                length: 4,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    // flexibleSpace:
                    title: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10.0), //Not working
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'Hey, ',
                                style: TextStyle(fontWeight: FontWeight.w300)),
                            TextSpan(text: '${user?.firstName ?? ''}'),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: _.onProfileImageTapped,
                          child: UserProgressImage(user: user),
                        ),
                      )
                    ],
                    bottom: TabBar(
                      tabs: [
                        SizedBox(height: 30, child: Text('Today')),
                        SizedBox(height: 30, child: Text('Inbox')),
                        SizedBox(height: 30, child: Text('Done')),
                        SizedBox(height: 30, child: Text('Missed')),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      TasksTab(type: TaskType.today),
                      TasksTab(type: TaskType.inbox),
                      TasksTab(type: TaskType.done),
                      TasksTab(type: TaskType.missed),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }
}
