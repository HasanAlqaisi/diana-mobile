import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/domain/repos/task_repo.dart';

class WatchTagsForTaskUseCase {
  final TaskRepo? taskRepo;

  WatchTagsForTaskUseCase(this.taskRepo);

  Stream<TaskWithTags> call(String taskId) {
    return taskRepo!.watchTagsForTask(taskId);
  }
}
