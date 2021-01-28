import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/domain/repos/task_repo.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';

class InsertTagUseCase {
  final TaskRepo taskRepo;

  InsertTagUseCase({this.taskRepo});

  Future<Either<Failure, TagResult>> call(String name, int color) {
    return taskRepo.insertTag(name, color);
  }
}
