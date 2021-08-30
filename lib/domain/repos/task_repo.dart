import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/task/task_result.dart';

abstract class TaskRepo {
  Future<Either<Failure, TagResponse>> getTags();

  Future<Either<Failure, TagResult>> insertTag(String name, int color);

  Future<Either<Failure, TagResult>> editTag(String id, String name, int color);

  Future<Either<Failure, bool>> deleteTag(String id);

  Future<Either<Failure, SubtaskResponse>> getSubtasks(String taskId);

  Future<Either<Failure, SubtaskResult>> insertSubtask(
    String name,
    bool isDone,
    String taskId,
  );

  Future<Either<Failure, SubtaskResult>> editSubtask(
    String subtaskId,
    String name,
    bool isDone,
    String taskId,
  );

  Future<Either<Failure, TaskResult>> makeTaskDone(String taskId);

  Future<Either<Failure, bool>> deleteSubtask(String subtaskId);

  Future<Either<Failure, TaskResponse>> getTasks();

  Future<Either<Failure, TaskResult>> insertTask(
    String name,
    String? note,
    String? date,
    List<String>? tags,
    List<String?>? checklist,
    String? reminder,
    String? deadline,
    int? priority,
    bool? done,
  );

  Future<Either<Failure, TaskResult>> editTask(
    String taskId,
    String name,
    String note,
    String? date,
    List<String> tags,
    List<String?> checklist,
    String? reminder,
    String? deadline,
    int priority,
    bool done,
  );

  Future<Either<Failure, bool>> deleteTask(String taskId);

  // Future<Either<Failure, TaskTagResponse>> insertTaskTag(
  //     String taskId, String tagId);

  // Future<Either<Failure, TaskTagResponse>> editTaskTag(
  //   String id,
  //   String taskId,
  //   String tagId,
  // );

  // Future<Either<Failure, bool>> deleteTaskTag(String id);

  Stream<List<TaskWithSubtasks>> watchTodayTasks(List<String> tags);

  Stream<List<TaskWithSubtasks>> watchAllTasks(List<String> tags);

  Stream<List<TaskWithSubtasks>> watchCompletedTasks(List<String> tags);

  Stream<List<TaskWithSubtasks>> watchMissedTasks(List<String> tags);

  Stream<List<TagData>> watchAllTags();

  Stream<TaskWithTags> watchTagsForTask(String taskId);
}
