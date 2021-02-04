import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/domain/repos/task_repo.dart';

class WatchCompletedTasksUseCase {
  final TaskRepo taskRepo;

  WatchCompletedTasksUseCase(this.taskRepo);

  Stream<List<TaskWithSubtasks>> call() {
    return taskRepo.watchCompletedTasks();
  }
}