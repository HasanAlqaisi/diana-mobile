import 'package:dartz/dartz.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';

abstract class HabitRepo {
  Future<Either<Failure, HabitlogResponse>> getHabitlogs(
    int offset,
    String habitId,
  );

  Future<Either<Failure, HabitlogResult>> insertHabitlog(
    String habitId,
  );
}
