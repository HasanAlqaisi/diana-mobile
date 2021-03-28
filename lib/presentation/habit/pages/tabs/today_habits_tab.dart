import 'package:diana/core/constants/enums.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/widgets/habits_list.dart';
import 'package:diana/presentation/task/widgets/quick_add_field.dart';
import 'package:flutter/widgets.dart';

class TodayHabitsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: QuickAddField(
            hint: 'Quick habit',
            onSubmitted: (habitName) {
              HabitController.to.insertHabit(habitName, [], null);
            },
          ),
        ),
        HabitsList(type: HabitType.today),
      ],
    );
  }
}
