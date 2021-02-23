import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/mappers/date_to_ymd_string.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:diana/injection_container.dart' as di;
import 'package:diana/presentation/task/controller/add_task_controller.dart';
import 'package:diana/presentation/task/widgets/tags_chips.dart';

class AddTaskScreen extends StatefulWidget {
  static const route = '/add_task';

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

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
            builder: (_) => Form(
              key: _formKey,
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
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    child: TextFormField(
                      style: TextStyle(color: Color(0xFFA687FF)),
                      decoration: InputDecoration(
                        labelText: 'Task title',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'eg. meeting appointment',
                        hintStyle: TextStyle(color: Color(0xFFA687FF)),
                        errorText: null,
                      ),
                      validator: (title) {
                        _.taskName = title;
                        if (title.isEmpty) return requireFieldMessage;
                        return null;
                      },
                    ),
                  ),

                  Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            _.subtasks.length == 0 ? 1 : _.subtasks.length + 1,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemBuilder: (context, index) {
                          return SubtaskField(
                            // key: ValueKey<int>(_.subtasks.length),
                            index: index,
                          );
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24),
                    child: TextFormField(
                      style: TextStyle(color: Color(0xFFA687FF)),
                      decoration: InputDecoration(
                        labelText: 'Note',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      validator: (note) {
                        _.note = note;
                        return null;
                      },
                    ),
                  ),

                  ///Starting date, priority, reminder (same starting date but different time) and deadline
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
                                  _.startingDate.value = dateToYMDString(
                                    await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(Duration(days: 60)),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4A15B5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Obx(() => Text(
                                        _dateFieldFormatter(
                                            _.startingDate.value),
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
                                _.startingDate.value.isNotEmpty,
                            onChanged: (newValue) {
                              _.shouldRemind.value = newValue;
                              if (newValue == true) {
                                _.reminderTime.value =
                                    '${_.startingDate.value}T${TimeOfDay.now().hour}:${TimeOfDay.now().minute}';
                              }
                            },
                            checkColor: Colors.black,
                            activeColor: Colors.white,
                          ),
                          Text(
                            'Remind me',
                            style: TextStyle(
                              color: _.shouldRemind.value
                                  ? Colors.white
                                  : Color(0xFF4A15B5),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Visibility(
                            visible: _.shouldRemind.value,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
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
                                        .then((time) => AddTaskController
                                                .to.reminderTime.value =
                                            '${_.startingDate.value}T${time.hour}:${time.minute}');
                                  },
                                  child: Text(
                                    '${AddTaskController.to.reminderTime.value}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
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
                              _.deadlineDate.value =
                                  dateToDjangotring(await showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.now().add(Duration(days: 1)),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 60)),
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(0xFF4A15B5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Obx(() => Text(
                                    _dateFieldFormatter(_.deadlineDate.value),
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
                        // labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _.onTagPlusClicked();
                          },
                          child: Icon(Icons.add, color: Color(0xFFA687FF)),
                        ),
                      ),
                    ),
                  ),
                  TagChips(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _.onTaskPlusClicked();
                          }
                        },
                        child: Icon(
                          Icons.check_circle_sharp,
                          color: Colors.white,
                          size: 60.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _dateFieldFormatter(String date) {
    if (date.isEmpty) {
      return 'Choose a date';
    } else {
      return date;
    }
  }
}

class SubtaskField extends StatelessWidget {
  final int index;

  const SubtaskField({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index == AddTaskController.to.subtasks.length)
          GestureDetector(
            onTap: () {
              AddTaskController.to.subtasks.add(SubtaskField(
                  key: key, index: AddTaskController.to.subtasks.length));
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
              child: Text(
                '+ Sub task',
                style: TextStyle(color: Color(0xFFD6C8FF)),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: TextStyle(color: Color(0xFFA687FF)),
              decoration: InputDecoration(
                  hintText: 'New sub task',
                  hintStyle: TextStyle(color: Color(0xFFA687FF)),
                  prefixIcon: GestureDetector(
                    onTap: () {
                      AddTaskController.to.subtasks.removeAt(index);
                    },
                    child: Icon(FontAwesomeIcons.minus, color: Colors.white),
                  )
                  // suffixIcon: Icon(Icons.add,
                  //     color: Color(0xFFA687FF)),
                  ),
              validator: (subtaskName) {
                if (subtaskName.isEmpty) return requireFieldMessage;
                AddTaskController.to.subtasksNames.add(subtaskName);
                return null;
              },
            ),
          ),
      ],
    );
  }
}
