import 'package:diana/core/constants/enums.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/pages/add_habit_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/route_manager.dart';

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
                      final isHabitDone =
                          controller.isHabitDone(data[index].doneDays);
                      return Padding(
                        key: ObjectKey(data[index]),
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onLongPress: () {
                            print('long tapped!');
                            controller.isLongPressed.value = true;
                          },
                          child: PhysicalModel(
                            color: Colors.white,
                            elevation: 0.8,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: isHabitDone
                                    ? LinearGradient(
                                        colors: [
                                          Color(0xFF612EF3),
                                          Color(0xFF0052CC),
                                        ],
                                        begin: Alignment.centerRight,
                                        end: Alignment.centerLeft,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Obx(
                                () => ExpansionTile(
                                  title: Text(data[index].habit.name,
                                      style: isHabitDone
                                          ? TextStyle(
                                              color: Color(0xFF7EF0FF),
                                              decoration:
                                                  TextDecoration.lineThrough)
                                          : null),
                                  trailing:
                                      _buildTrailing(data[index], isHabitDone),
                                  backgroundColor: isHabitDone
                                      ? Color(0xFF4E34EB)
                                      : Colors.white,
                                  // childrenPadding:
                                  // EdgeInsets.symmetric(horizontal: 16),
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
                                    Container(
                                      color: isHabitDone
                                          ? Color(0xFF4E34EB)
                                          : null,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          DayText(
                                            key: ValueKey('Mon'),
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
                                            key: ValueKey('Tue'),
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
                                            key: ValueKey('Wed'),
                                            text: 'Wed',
                                            color: controller.dayColor(
                                              DateTime.wednesday - 1,
                                              data[index],
                                            ),
                                            hasBorder: now.weekday ==
                                                DateTime.wednesday,
                                          ),
                                          Text(' | '),
                                          DayText(
                                            key: ValueKey('Thu'),
                                            text: 'Thu',
                                            color: controller.dayColor(
                                              DateTime.thursday - 1,
                                              data[index],
                                            ),
                                            hasBorder: now.weekday ==
                                                DateTime.thursday,
                                          ),
                                          Text(' | '),
                                          DayText(
                                            key: ValueKey('Fri'),
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
                                            key: ValueKey('Sat'),
                                            text: 'Sat',
                                            color: controller.dayColor(
                                              DateTime.saturday - 1,
                                              data[index],
                                            ),
                                            hasBorder: now.weekday ==
                                                DateTime.saturday,
                                          ),
                                          Text(' | '),
                                          DayText(
                                            key: ValueKey('Sun'),
                                            text: 'Sun',
                                            color: controller.dayColor(
                                              DateTime.sunday - 1,
                                              data[index],
                                            ),
                                            hasBorder:
                                                now.weekday == DateTime.sunday,
                                          )
                                        ],
                                      ),
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

  Widget _buildTrailing(HabitWitLogsWithDays data, bool isHabitDone) {
    final controller = HabitController.to;
    final selectedHabit = controller.selectedHabit.value;
    if (selectedHabit == data.habit.id) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              FontAwesomeIcons.trash,
              color: isHabitDone ? Colors.white : Colors.red,
            ),
            highlightColor: Colors.transparent,
            constraints: BoxConstraints(minWidth: 20, minHeight: 20),
            onPressed: () async {
              await controller.deleteHabit(data.habit.id);
            },
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.pen,
              color: isHabitDone ? Colors.white : null,
            ),
            highlightColor: Colors.transparent,
            constraints: BoxConstraints(minWidth: 20, minHeight: 20),
            onPressed: () async {
              await Get.bottomSheet(
                AddHabitBottomSheet(habit: data),
                isDismissible: false,
              );
              controller.clearHabitInfo();
            },
          ),
        ],
      );
    } else {
      if (controller.isHabitForThisDay(data.days) && !isHabitDone) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
                onTap: () async {
                  await controller.onHabitMarked(data.habit.id);
                },
                child:
                    Icon(Icons.check_circle, color: Colors.grey, size: 30.0)),
          ],
        );
      } else {
        return null;
      }
    }
  }
}
