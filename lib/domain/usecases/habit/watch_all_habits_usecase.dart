import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class WatchAllHabitUseCase {
  final HabitRepo habitRepo;

  WatchAllHabitUseCase(this.habitRepo);

  Stream<Future<List<HabitWitLogsWithDays>>> call() {
    return habitRepo.watchAllHabits();
  }
}
