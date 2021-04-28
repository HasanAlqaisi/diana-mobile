import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/date/date_helper.dart';
import 'package:diana/core/utils/progress_loader.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/widgets/day_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AddHabitBottomSheet extends StatelessWidget {
  static const route = '/add_habit';

  final HabitWitLogsWithDays habit;

  const AddHabitBottomSheet({Key key, this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = HabitController.to;
    _.setHabitFields(habit);
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFF0052CC),
            Color(0xFF612EF3),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Form(
          key: _.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Create New Habit',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: TextFormField(
                  controller: _.habitTitleController,
                  style: TextStyle(color: Color(0xFFA687FF)),
                  decoration: InputDecoration(
                    labelText: 'Habit title',
                    labelStyle: TextStyle(color: Colors.white),
                    errorText: null,
                  ),
                  validator: (title) {
                    if (title.trim().isEmpty) return requireFieldMessage;
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Days of Week',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF2A78EC),
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.all(12),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          key: ValueKey('Mon'),
                          onTap: () {
                            _addWeekDay(0, _);
                          },
                          child: DayText(
                              text: 'Mon',
                              color: _colorDayText(weekDay: 0, controller: _),
                              hasBorder: false)),
                      GestureDetector(
                          key: ValueKey('Tue'),
                          onTap: () {
                            _addWeekDay(1, _);
                          },
                          child: DayText(
                              text: 'Tue',
                              color: _colorDayText(weekDay: 1, controller: _),
                              hasBorder: false)),
                      GestureDetector(
                          key: ValueKey('Wed'),
                          onTap: () {
                            _addWeekDay(2, _);
                          },
                          child: DayText(
                              text: 'Wed',
                              color: _colorDayText(weekDay: 2, controller: _),
                              hasBorder: false)),
                      GestureDetector(
                          key: ValueKey('Thu'),
                          onTap: () {
                            _addWeekDay(3, _);
                          },
                          child: DayText(
                              text: 'Thu',
                              color: _colorDayText(weekDay: 3, controller: _),
                              hasBorder: false)),
                      GestureDetector(
                          key: ValueKey('Fri'),
                          onTap: () {
                            _addWeekDay(4, _);
                          },
                          child: DayText(
                              text: 'Fri',
                              color: _colorDayText(weekDay: 4, controller: _),
                              hasBorder: false)),
                      GestureDetector(
                          key: ValueKey('Sat'),
                          onTap: () {
                            _addWeekDay(5, _);
                          },
                          child: DayText(
                              text: 'Sat',
                              color: _colorDayText(weekDay: 5, controller: _),
                              hasBorder: false)),
                      GestureDetector(
                          key: ValueKey('Sun'),
                          onTap: () {
                            _addWeekDay(6, _);
                          },
                          child: DayText(
                              text: 'Sun',
                              color: _colorDayText(weekDay: 6, controller: _),
                              hasBorder: false))
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Checkbox(
                        value: _.shouldRemind.value,
                        onChanged: (newValue) {
                          _.shouldRemind.value = newValue;
                        },
                        checkColor: Colors.black,
                        activeColor: Colors.white,
                      ),
                      Text(
                        'Remind me',
                        style: TextStyle(
                          color: _.shouldRemind.value
                              ? Colors.white
                              : Color(0xFF2123C3),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Visibility(
                        visible: _.shouldRemind.value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFF2123C3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((time) {
                                  if (time != null) {
                                    _.reminderTime.value = DateHelper
                                        .convertHour12FormatTo24Format(
                                      time.format(context),
                                    );
                                  }
                                });
                              },
                              child: _.reminderTime.value.isNotEmpty
                                  ? Text(
                                      _.reminderTime.value.substring(0, 5),
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      '00:00',
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
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.check_circle_sharp,
                      color: Colors.white,
                    ),
                    iconSize: 60.0,
                    onPressed: () async {
                      if (_.formKey.currentState.validate()) {
                        showLoaderDialog();
                        await _.insertHabit(
                          habitName: _.habitTitleController.text,
                          days: _.days,
                          time: _.reminderTime.value,
                        );
                        Get.back();
                        Get.back();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Color _colorDayText({int weekDay, HabitController controller}) {
  return !controller.days.contains(weekDay) ? Colors.white : Color(0xFF00FFEF);
}

void _addWeekDay(int weekDay, HabitController _) {
  if (!_.days().contains(weekDay)) {
    _.days().add(weekDay);
  } else {
    _.days().remove(weekDay);
  }
  _.days.refresh();
}
