import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';

abstract class TaskRepo {
  Future<Either<Failure, TagResponse>> getTags(int offset);

  Future<Either<Failure, TagResult>> insertTag(String name, int color);

  Future<Either<Failure, TagResult>> editTag(String id, String name, int color);

  Future<Either<Failure, SubtaskResponse>> getSubtasks(
      String taskId, int offset);

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

  Future<Either<Failure, bool>> deleteSubtask(String subtaskId);

  Future<Either<Failure, TaskResponse>> getTasks(int offset);

  Future<Either<Failure, TaskResult>> insertTask(
    String name,
    String note,
    String reminder,
    String deadline,
    int priority,
    bool done,
  );

  Future<Either<Failure, TaskResult>> editTask(
    String taskId,
    String name,
    String note,
    String reminder,
    String deadline,
    int priority,
    bool done,
  );

  Future<Either<Failure, bool>> deleteTask(String taskId);

  Future<Either<Failure, TaskTagResponse>> insertTaskTag(
      String taskId, String tagId);

  Future<Either<Failure, TaskTagResponse>> editTaskTag(
    String id,
    String taskId,
    String tagId,
  );

  Future<Either<Failure, bool>> deleteTaskTag(String id);
}
