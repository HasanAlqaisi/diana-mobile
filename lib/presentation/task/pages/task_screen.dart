import 'package:diana/presentation/task/pages/today_task_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskScreen extends StatelessWidget {
  static const route = '/task';

  @override
  Widget build(BuildContext context) {
    return TabBarView(children: [
      TodayTaskTab(),
      TodayTaskTab(),
      TodayTaskTab(),
      TodayTaskTab(),
    ]);
  }
}
