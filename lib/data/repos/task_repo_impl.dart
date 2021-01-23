import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:diana/core/api_helpers/api.dart';

import 'package:diana/core/errors/exception.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/subtask/subtask_remote_source.dart';
import 'package:diana/data/data_sources/tag/tag_remote_source.dart';
import 'package:diana/data/data_sources/task/task_remote_source.dart';
import 'package:diana/data/data_sources/tasktag/tasktag_remote_source.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';
import 'package:diana/domain/repos/task_repo.dart';

class TaskRepoImpl extends TaskRepo {
  final NetWorkInfo netWorkInfo;
  final TaskRemoteSource taskRemoteSource;
  final SubtaskRemoteSource subtaskRemoteSource;
  final TagRemoteSource tagRemoteSource;
  final TaskTagRemoteSource taskTagRemoteSource;
  int taskOffset = 0, subtaskOffset = 0, tagOffset = 0;

  TaskRepoImpl({
    this.netWorkInfo,
    this.taskRemoteSource,
    this.subtaskRemoteSource,
    this.tagRemoteSource,
    this.taskTagRemoteSource,
  });

  @override
  Future<Either<Failure, bool>> deleteSubtask(String subtaskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await subtaskRemoteSource.deleteSubtask(subtaskId);
        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTask(String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskRemoteSource.deleteTask(taskId);
        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteTaskTag(String id) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskTagRemoteSource.deleteTaskTag(id);
        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, SubtaskResult>> editSubtask(
      String subtaskId, String name, bool isDone, String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await subtaskRemoteSource.editSubtask(
            subtaskId, name, isDone, taskId);
        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          SubtaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TagResult>> editTag(
      String id, String name, int color) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await tagRemoteSource.editTag(id, name, color);
        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          TagFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TaskResult>> editTask(
    String taskId,
    String name,
    String note,
    String reminder,
    String deadline,
    int priority,
    bool done,
  ) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskRemoteSource.editTask(
            taskId, name, note, reminder, deadline, priority, done);
        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          TaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TaskTagResponse>> editTaskTag(
      String id, String taskId, String tagId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskTagRemoteSource.editTaskTag(id, taskId, tagId);
        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          TaskTagFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on NotFoundException {
        return Left(NotFoundFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, SubtaskResponse>> getSubtasks(String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await subtaskRemoteSource.getSubtasks(taskId, subtaskOffset);

        final offset = API.offsetExtractor(result.next);

        subtaskOffset = offset;

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TagResponse>> getTags() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await tagRemoteSource.getTags(tagOffset);

        final offset = API.offsetExtractor(result.next);

        tagOffset = offset;

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TaskResponse>> getTasks() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskRemoteSource.getTasks(taskOffset);

        final offset = API.offsetExtractor(result.next);

        taskOffset = offset;

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, SubtaskResult>> insertSubtask(
      String name, bool isDone, String taskId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await subtaskRemoteSource.insertSubtask(name, isDone, taskId);
        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          SubtaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TagResult>> insertTag(String name, int color) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await tagRemoteSource.insertTags(name, color);
        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          TagFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TaskResult>> insertTask(String name, String note,
      String reminder, String deadline, int priority, bool done) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskRemoteSource.insertTask(
            name, note, reminder, deadline, priority, done);
        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          TaskFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Future<Either<Failure, TaskTagResponse>> insertTaskTag(
      String taskId, String tagId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await taskTagRemoteSource.insertTaskTag(taskId, tagId);
        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          TaskTagFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}
