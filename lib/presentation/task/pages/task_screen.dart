import 'package:cached_network_image/cached_network_image.dart';
import 'package:diana/presentation/profile/pages/profile_screen.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/pages/tabs/done_task_tab.dart';
import 'package:diana/presentation/task/pages/tabs/missed_task_tab.dart';
import 'package:diana/presentation/task/pages/tabs/inbox_task_tab.dart';
import 'package:diana/presentation/task/pages/tabs/today_task_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:diana/injection_container.dart' as di;

class TaskScreen extends StatelessWidget {
  static const route = '/task';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // flexibleSpace:
          title: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0), //Not working
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: 'Hey, ',
                      style: TextStyle(fontWeight: FontWeight.w300)),
                  TextSpan(text: 'Hasan! '),
                ],
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(ProfileScreen.route);
                },
                child: CircularStepProgressIndicator(
                  totalSteps: 100,
                  currentStep: 50,
                  selectedColor: Color(0xFF00FFEF),
                  unselectedColor: Colors.white,
                  padding: 0,
                  width: 40,
                  stepSize: 3,
                  child: CircleAvatar(
                    radius: 45,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://i.pinimg.com/564x/d9/56/9b/d9569bbed4393e2ceb1af7ba64fdf86a.jpg',
                      ),
                    ),
                  ),
                ),
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
        body: GetBuilder<TaskController>(
          init: di.sl<TaskController>(),
          builder: (_) {
            return TabBarView(children: [
              TodayTaskTab(),
              InboxTaskTab(),
              DoneTaskTab(),
              MissedTaskTab(),
            ]);
          },
        ),
      ),
    );
  }
}
