import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';

abstract class MainRepo {
  Future<Either<Failure, TagResponse>> getTags();

  Future<Either<Failure, TagResult>> insertTag(String name, int color);

  Future<Either<Failure, TagResult>> editTag(String id, String name, int color);

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

  Future<Either<Failure, bool>> deleteSubtask(String subtaskId);
}
