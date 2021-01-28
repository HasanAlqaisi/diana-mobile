import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';
import 'package:diana/domain/repos/task_repo.dart';

class InsertTasktagUseCase {
  final TaskRepo taskRepo;

  InsertTasktagUseCase({this.taskRepo});

  Future<Either<Failure, TaskTagResponse>> call(String taskId, tagId) {
    return taskRepo.insertTaskTag(taskId, tagId);
  }
}
