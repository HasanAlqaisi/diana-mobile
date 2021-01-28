import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';
import 'package:diana/domain/repos/task_repo.dart';

class EditTasktagUseCase {
  final TaskRepo taskRepo;

  EditTasktagUseCase({this.taskRepo});

  Future<Either<Failure, TaskTagResponse>> call(
    String id,
    String taskId,
    String tagId,
  ) {
    return taskRepo.editTaskTag(id, taskId, tagId);
  }
}
