import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/habit/habit_local_source.dart';
import 'package:diana/data/data_sources/habit/habit_remote_source.dart';
import 'package:diana/data/data_sources/habitlog/habitlog_remote_source.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:diana/domain/repos/habit_repo.dart';
import 'package:flutter/material.dart';

class HabitRepoImpl extends HabitRepo {
  final NetWorkInfo netWorkInfo;
  final HabitRemoteSource habitRemoteSource;
  final HabitlogRemoteSource habitlogRemoteSource;
  final HabitLocalSource habitLocalSource;
  int habitOffset = 0, habitlogOffset = 0;

  HabitRepoImpl({
    this.netWorkInfo,
    this.habitRemoteSource,
    this.habitlogRemoteSource,
    this.habitLocalSource,
    this.habitOffset,
  });

  @override
  Future<Either<Failure, HabitResponse>> getHabits() async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await habitRemoteSource.getHabits(habitOffset);

        debugPrint('getHabits => API result is $result');

        if (habitOffset == 0) {
          await habitLocalSource.deleteAndinsertHabits(result);
        } else {
          await habitLocalSource.insertHabits(result);
        }

        final offset = API.offsetExtractor(result.next);

        habitOffset = offset;

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
  Future<Either<Failure, HabitResult>> insertHabit(
      String name, List<int> days, String time) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await habitRemoteSource.insertHabit(name, days, time);

        debugPrint('insertHabit => API result is $result');

        await habitLocalSource.insertHabit(result);

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          HabitFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
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
  Future<Either<Failure, HabitResult>> editHabit(
      String habitId, String name, List<int> days, String time) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await habitRemoteSource.editHabit(habitId, name, days, time);

        debugPrint('editHabit => API result is $result');

        await habitLocalSource.insertHabit(result);

        return Right(result);
      } on FieldsException catch (error) {
        return Left(
          HabitFieldsFailure.fromFieldsException(json.decode(error.body)),
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
  Future<Either<Failure, bool>> deleteHabit(String habitId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await habitRemoteSource.deleteHabit(habitId);

        debugPrint('deleteHabit => API result is $result');

        await habitLocalSource.deleteHabit(habitId);

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
  Future<Either<Failure, HabitlogResponse>> getHabitlogs(String habitId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result =
            await habitlogRemoteSource.getHabitlogs(habitlogOffset, habitId);

        debugPrint('getHabitLogs => API result is $result');

        if (habitlogOffset == 0) {
          await habitLocalSource.deleteAndinsertHabitlogs(result);
        } else {
          await habitLocalSource.insertHabitlogs(result);
        }

        final offset = API.offsetExtractor(result.next);

        habitlogOffset = offset;

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
  Future<Either<Failure, HabitlogResult>> insertHabitlog(String habitId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await habitlogRemoteSource.insertHabitlog(habitId);

        debugPrint('insertHabitLog => API result is $result');

        await habitLocalSource.insertHabitlog(result);

        return Right(result);
      } on UnAuthException {
        return Left(UnAuthFailure());
      } on FieldsException catch (error) {
        return Left(
          HabitlogFieldsFailure.fromFieldsException(json.decode(error.body)),
        );
      } on UnknownException catch (error) {
        return Left(UnknownFailure(message: error.message));
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  @override
  Stream<Future<List<HabitWitLogsWithDays>>> watchAllHabits() {
    return habitLocalSource.watchAllHabits(kUserId);
  }

  @override
  Stream<Future<List<HabitWitLogsWithDays>>> watchTodayHabits(int day) {
    return habitLocalSource.watchTodayHabits(kUserId, day);
  }
}
