import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/domain/repos/task_repo.dart';

class WatchAllTagsUseCase {
  final TaskRepo? taskRepo;

  WatchAllTagsUseCase(this.taskRepo);

  Stream<List<TagData>> call() {
    return taskRepo!.watchAllTags();
  }
}
