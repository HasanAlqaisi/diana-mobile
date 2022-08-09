import 'package:diana/core/constants/enums.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/habit/widgets/habits_list.dart';
import 'package:diana/presentation/task/widgets/quick_add_field.dart';
import 'package:flutter/widgets.dart';

class HabitsTab extends StatelessWidget {
  final HabitType? habitType;
  final controller = HabitController.to;

  HabitsTab({Key? key, this.habitType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: QuickAddField(
            textController: controller.quickHabitController,
            hint: 'Quick habit',
            onSubmitted: (habitName) {
              controller.insertHabit(habitName: habitName, days: []);
            },
            errorText: controller.failure is HabitFieldsFailure
                ? (controller.failure as HabitFieldsFailure?)?.name?.first
                : null,
          ),
        ),
        HabitsList(type: habitType),
      ],
    );
  }
}
