import 'dart:convert';

import 'package:diana/core/errors/exception.dart';
import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/habit/habit_remote_source.dart';
import 'package:diana/data/data_sources/habitlog/habitlog_remote_source.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:diana/domain/repos/habit_repo.dart';

class HabitRepoImpl extends HabitRepo {
  final NetWorkInfo netWorkInfo;
  final HabitRemoteSource habitRemoteSource;
  final HabitlogRemoteSource habitlogRemoteSource;

  HabitRepoImpl(
      {this.netWorkInfo, this.habitRemoteSource, this.habitlogRemoteSource});

  @override
  Future<Either<Failure, HabitResponse>> getHabits(int offset) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await habitRemoteSource.getHabits(offset);
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
  Future<Either<Failure, HabitlogResponse>> getHabitlogs(
      int offset, String habitId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await habitlogRemoteSource.getHabitlogs(offset, habitId);
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
}
