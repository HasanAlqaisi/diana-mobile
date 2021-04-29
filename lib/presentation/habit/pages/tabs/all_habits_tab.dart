import 'package:diana/core/constants/enums.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/widgets/habits_list.dart';
import 'package:diana/presentation/task/widgets/quick_add_field.dart';
import 'package:flutter/widgets.dart';

class AllHabitsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = HabitController.to;
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: QuickAddField(
            hint: 'Quick habit',
            textController: controller.quickHabitController,
            onSubmitted: (habitName) async {
              await controller.insertHabit(habitName: habitName, days: []);
              controller.quickHabitController.text = '';
            },
            errorText: controller.failure is HabitFieldsFailure
                ? (controller.failure as HabitFieldsFailure)?.name?.first
                : null,
          ),
        ),
        HabitsList(type: HabitType.inbox),
      ],
    );
  }
}
