import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/utils/progress_loader.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/subtask_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:diana/injection_container.dart' as di;
import 'package:diana/presentation/task/controller/add_task_controller.dart';

class AddTaskScreen extends StatelessWidget {
  static const route = '/add_task';

  final data = (Get.arguments as List<dynamic>);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFf852EF3), Color(0xFF612EF3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: GetBuilder<AddTaskController>(
            init: di.sl<AddTaskController>(),
            builder: (_) {
              _.setTaskInfo(data);
              return Form(
                key: _.formKey,
                child: ListView(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Create New Task',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24.0),
                      child: TextFormField(
                        controller: _.taskTitleController,
                        style: TextStyle(color: Color(0xFFA687FF)),
                        decoration: InputDecoration(
                          labelText: 'Task title',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'eg. meeting appointment',
                          hintStyle: TextStyle(color: Color(0xFFA687FF)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA687FF), width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA687FF), width: 0.5),
                          ),
                          errorText: null,
                        ),
                        validator: (title) {
                          _.taskName = title;
                          if (title.trim().isEmpty) return requireFieldMessage;
                          return null;
                        },
                      ),
                    ),
                    Obx(
                      () => ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          ..._.subtasks,
                          GestureDetector(
                            onTap: () {
                              _.subtasks.add(
                                SubtaskField(
                                  key: UniqueKey(),
                                  index: _.subtasks.length,
                                  removeField: _.removeField,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              child: Text(
                                '+ Sub task',
                                style: TextStyle(color: Color(0xFFD6C8FF)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24),
                      child: TextFormField(
                        controller: _.noteController,
                        style: TextStyle(color: Color(0xFFA687FF)),
                        decoration: InputDecoration(
                          labelText: 'Note',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA687FF), width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA687FF), width: 0.5),
                          ),
                        ),
                        validator: (note) {
                          _.note = note;
                          return null;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.0, top: 16.0),
                                child: Text(
                                  'Date',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(Duration(days: 60)),
                                    ).then((startingDate) {
                                      if (startingDate != null) {
                                        _.date.value = startingDate;
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF4A15B5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Obx(() => Text(
                                          _.dateFieldFormatter(_.date.value),
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Priority',
                                  style: TextStyle(color: Colors.white)),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 16.0, left: 8.0, right: 16.0),
                                child: Obx(
                                  () => Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (_.priority.value == 1) {
                                            _.priority.value = 0;
                                            return;
                                          }
                                          _.priority.value = 1;
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF4A15B5),
                                            shape: BoxShape.circle,
                                            border: _.priority.value == 1
                                                ? Border.all(
                                                    color: Color(0xFFA687FF))
                                                : null,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: 20,
                                          child: Divider(
                                              color: Color(0xFF4A15B5),
                                              thickness: 4)),
                                      GestureDetector(
                                        onTap: () {
                                          if (_.priority.value == 2) {
                                            _.priority.value = 0;
                                            return;
                                          }
                                          _.priority.value = 2;
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF4A15B5),
                                            shape: BoxShape.circle,
                                            border: _.priority.value == 2
                                                ? Border.all(
                                                    color: Color(0xFFA687FF))
                                                : null,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: 20,
                                          child: Divider(
                                              color: Color(0xFF4A15B5),
                                              thickness: 4)),
                                      GestureDetector(
                                        onTap: () {
                                          if (_.priority.value == 3) {
                                            _.priority.value = 0;
                                            return;
                                          }
                                          _.priority.value = 3;
                                        },
                                        child: Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF4A15B5),
                                            shape: BoxShape.circle,
                                            border: _.priority.value == 3
                                                ? Border.all(
                                                    color: Color(0xFFA687FF))
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Obx(
                        () => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: _.shouldRemind.value &&
                                  _.date.value?.year != 0,
                              onChanged: (newValue) {
                                _.shouldRemind.value = newValue;
                              },
                              checkColor: Colors.black,
                              activeColor: Colors.white,
                            ),
                            Text(
                              'Remind me',
                              style: TextStyle(
                                color: _.shouldRemind.value &&
                                        _.date.value?.year != 0
                                    ? Colors.white
                                    : Color(0xFF4A15B5),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Visibility(
                              visible: _.shouldRemind.value &&
                                  _.date.value?.year != 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4A15B5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: GestureDetector(
                                      onTap: () async {
                                        await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now())
                                            .then((time) {
                                          if (time != null) {
                                            _.date.value = DateTime(
                                              _.date.value.year,
                                              _.date.value.month,
                                              _.date.value.day,
                                              time.hour,
                                              time.minute,
                                            );
                                          }
                                        });
                                      },
                                      child: Text(
                                        '${_.date.value?.hour}:${_.date.value?.minute}',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8.0, top: 16.0),
                            child: Text('Deadline',
                                style: TextStyle(color: Colors.white)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 8.0),
                            child: GestureDetector(
                              onTap: () async {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      final currentDate = DateTime.now();
                                      return CupertinoDatePicker(
                                        mode:
                                            CupertinoDatePickerMode.dateAndTime,
                                        initialDateTime: DateTime(
                                            currentDate.year,
                                            currentDate.month,
                                            currentDate
                                                .add(Duration(days: -1))
                                                .day,
                                            currentDate.hour,
                                            currentDate.minute),
                                        onDateTimeChanged: (deadline) {
                                          _.deadline.value = deadline;
                                        },
                                        use24hFormat: false,
                                        minuteInterval: 1,
                                      );
                                    });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4A15B5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Obx(() => Text(
                                      _.dateFieldFormatter(_.deadline.value),
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 24),
                      child: TextFormField(
                        onChanged: (tag) {
                          _.tag = tag;
                        },
                        style: TextStyle(color: Color(0xFFA687FF)),
                        decoration: InputDecoration(
                          errorText: null,
                          // labelText: 'Tags',
                          hintText: 'New Tag...',
                          hintStyle: TextStyle(color: Color(0xFFA687FF)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA687FF), width: 0.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xFFA687FF), width: 0.5),
                          ),
                          // labelStyle: TextStyle(color: Colors.white),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.add, color: Color(0xFFA687FF)),
                            onPressed: () async {
                              showLoaderDialog();
                              await _.onTagPlusClicked();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    StreamBuilder<List<TagData>>(
                      stream: TaskController.to.watchAllTags(),
                      initialData: [],
                      builder: (context, snapshot) {
                        final data = snapshot?.data;
                        if (data != null && data.isNotEmpty) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Obx(
                              () => Row(
                                children: _.buildChips(data),
                              ),
                            ),
                          );
                        } else {
                          print('TAGS UI: data is empty ${data?.isEmpty}');
                          return Container();
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.check_circle_sharp,
                            color: Colors.white,
                          ),
                          iconSize: 60.0,
                          highlightColor: Colors.transparent,
                          onPressed: () async {
                            if (_.formKey.currentState.validate()) {
                              showLoaderDialog();
                              await _.onTaskPlusClicked();
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
