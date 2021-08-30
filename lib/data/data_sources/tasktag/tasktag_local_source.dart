import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/tasktag/tasktag_dao.dart';
import 'package:diana/data/database/relations/tag_with_tasks/tag_with_tasks.dart';
import 'package:moor/moor.dart';

abstract class TaskTagLocalSoucre {
  Future<void> insertTaskTag(TaskTagData taskTag);

  Stream<TagWithTasks> watchTodayTasksForTag(String id);

  Stream<TagWithTasks> watchAllTaskForTag(String id);

  Stream<TagWithTasks> watchCompletedTasksForTag(String id);

  Stream<TagWithTasks> watchMissedTasksForTag(String id);

  Future<int> deleteTaskTag(String taskId, tagId);
}

class TaskTagLocalSoucreImpl extends TaskTagLocalSoucre {
  final TaskTagDao? taskTagDao;

  TaskTagLocalSoucreImpl({this.taskTagDao});

  @override
  Future<void> insertTaskTag(TaskTagData taskTag) {
    try {
      return taskTagDao!.insertTaskTag(taskTag);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Stream<TagWithTasks> watchAllTaskForTag(String id) {
    return taskTagDao!.watchAllTaskForTag(id);
  }

  @override
  Stream<TagWithTasks> watchCompletedTasksForTag(String id) {
    return taskTagDao!.watchCompletedTasksForTag(id);
  }

  @override
  Stream<TagWithTasks> watchMissedTasksForTag(String id) {
    return taskTagDao!.watchMissedTasksForTag(id);
  }

  @override
  Stream<TagWithTasks> watchTodayTasksForTag(String id) {
    return taskTagDao!.watchTodayTasksForTag(id);
  }

  @override
  Future<int> deleteTaskTag(String taskId, tagId) {
    return taskTagDao!.deleteTaskTag(taskId, tagId);
  }
}
