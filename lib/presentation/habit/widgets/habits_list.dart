import 'package:diana/core/constants/enums.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:diana/presentation/task/widgets/subtasks_list.dart';
import 'package:diana/presentation/task/widgets/tags_row.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'day_text.dart';

class HabitsList extends StatelessWidget {
  final HabitType type;

  HabitsList({
    Key key,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = HabitController.to;
    final now = DateTime.now();

    return StreamBuilder<Future<List<HabitWitLogsWithDays>>>(
        stream: controller.watch(habitType: type),
        builder: (context, snapshot) {
          return FutureBuilder<List<HabitWitLogsWithDays>>(
            future: snapshot?.data,
            builder: (context, asyncData) {
              final data = asyncData.hasData ? asyncData?.requireData : null;
              if (data != null && data.isNotEmpty) {
                for (int i = 0; i < data.length; i++) {
                  data[i].doneDays =
                      controller.getLogsInCurrentWeekRange(data[i]);
                }
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                            controller.isLongPressed.value = true;
                          },
                          child: Material(
                            elevation: 0.8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                                // border: Border.all(color: Colors.grey, width: 0.5)
                              ),
                              child: Obx(
                                () => ExpansionTile(
                                  title: Text(data[index].habit.name),
                                  trailing: _buildTrailing(data[index]),
                                  backgroundColor: Colors.white,
                                  childrenPadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                  tilePadding:
                                      EdgeInsets.symmetric(horizontal: 16),
                                  onExpansionChanged: (isExpanded) {
                                    controller.isLongPressed.value = false;

                                    if (isExpanded) {
                                      print('tapped to Expanded');
                                      controller.selectedHabit.value =
                                          data[index].habit.id;
                                    } else {
                                      print('tapped to close');
                                      controller.selectedHabit.value = '';
                                    }
                                  },
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        DayText(
                                          text: 'Mon',
                                          color: controller.dayColor(
                                            DateTime.monday - 1,
                                            data[index],
                                          ),
                                          hasBorder:
                                              now.weekday == DateTime.monday,
                                        ),
                                        Text(' | '),
                                        DayText(
                                          text: 'Tue',
                                          color: controller.dayColor(
                                            DateTime.tuesday - 1,
                                            data[index],
                                          ),
                                          hasBorder:
                                              now.weekday == DateTime.tuesday,
                                        ),
                                        Text(' | '),
                                        DayText(
                                          text: 'Wed',
                                          color: controller.dayColor(
                                            DateTime.wednesday - 1,
                                            data[index],
                                          ),
                                          hasBorder:
                                              now.weekday == DateTime.wednesday,
                                        ),
                                        Text(' | '),
                                        DayText(
                                          text: 'Thu',
                                          color: controller.dayColor(
                                            DateTime.thursday - 1,
                                            data[index],
                                          ),
                                          hasBorder:
                                              now.weekday == DateTime.thursday,
                                        ),
                                        Text(' | '),
                                        DayText(
                                          text: 'Fri',
                                          color: controller.dayColor(
                                            DateTime.friday - 1,
                                            data[index],
                                          ),
                                          hasBorder:
                                              now.weekday == DateTime.friday,
                                        ),
                                        Text(' | '),
                                        DayText(
                                          text: 'Sat',
                                          color: controller.dayColor(
                                            DateTime.saturday - 1,
                                            data[index],
                                          ),
                                          hasBorder:
                                              now.weekday == DateTime.saturday,
                                        ),
                                        Text(' | '),
                                        DayText(
                                          text: 'Sun',
                                          color: controller.dayColor(
                                            DateTime.sunday - 1,
                                            data[index],
                                          ),
                                          hasBorder:
                                              now.weekday == DateTime.sunday,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                print('TASK UI: data is empty? ${data?.isEmpty}');
                return Container();
              }
            },
          );
        });
  }

  Widget _buildTrailing(HabitWitLogsWithDays data) {
    final selectedHabit = HabitController.to.selectedHabit.value;
    if (selectedHabit == data.habit.id) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FontAwesomeIcons.trash, color: Colors.red),
          SizedBox(width: 10),
          Icon(FontAwesomeIcons.pencilAlt),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () {
                print('check mark cliked');
                // HabitController.to.editHabit(
                //   taskData.id,
                //   taskData.name,
                //   taskData.note,
                //   taskData.date.toString(),
                //   tagsData.tags.map((tag) => tag.id).toList(),
                //   taskData.reminder.toString(),
                //   taskData.deadline.toString(),
                //   taskData.priority,
                //   true,
                // );
              },
              child: Icon(Icons.check_circle, color: Colors.grey, size: 30.0)),
        ],
      );
    }
  }
}
