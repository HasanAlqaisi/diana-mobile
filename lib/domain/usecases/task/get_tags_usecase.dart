import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/task_repo.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';

class GetTagsUseCase {
  final TaskRepo taskRepo;

  GetTagsUseCase({this.taskRepo});

  Future<Either<Failure, TagResponse>> call(String habitId) {
    return taskRepo.getTags();
  }
}
