import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';

import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/date/date_helper.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../injection_container.dart' as di;

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
  });

  @override
  Future<Either<Failure, HabitResponse>> getHabits() async {
    if (await netWorkInfo.isConnected()) {
      try {
        if (habitOffset != null) {
          final result = await habitRemoteSource.getHabits(habitOffset);

          log('API result is ${result.results}', name: 'getHabits');

          if (habitOffset == 0) {
            await habitLocalSource.deleteAndinsertHabits(result);
            await habitLocalSource.deleteAndinsertHabitlogs(result.results);
          } else {
            await habitLocalSource.insertHabits(result);
            await habitLocalSource.insertHabitlogs(result.results);
          }

          final offset = API.offsetExtractor(result.next);

          habitOffset = offset;

          return Right(result);
        } else {
          return Right(null);
          //TODO: return Left(NoMoreResultsFailure)
        }
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

        log('API result is $result', name: 'insertHabit');

        if (result.time != null) {
          final dates = DateHelper.getDatesFromWeekDays(days, time);
          dates.forEach((date) async {
            await di.sl<FlutterLocalNotificationsPlugin>().zonedSchedule(
                result.habitId.hashCode,
                null,
                'Time to ${result.name}!',
                tz.TZDateTime.parse(tz.local, date.toString()),
                di.sl.get(instanceName: habitNotificationInjectionName),
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
                matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
          });
        }

        await habitLocalSource.insertHabit(result);
        await habitLocalSource.insertHabitlog(result);

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

        log('API result is $result', name: 'editHabit');

        if (result.time != null) {
          await di.sl<FlutterLocalNotificationsPlugin>().zonedSchedule(
                result.habitId.hashCode,
                null,
                'Time to ${result.name}!',
                tz.TZDateTime.parse(tz.local, result.time),
                di.sl.get(instanceName: habitNotificationInjectionName),
                androidAllowWhileIdle: true,
                uiLocalNotificationDateInterpretation:
                    UILocalNotificationDateInterpretation.absoluteTime,
              );
        }

        await habitLocalSource.insertHabit(result);
        await habitLocalSource.insertHabitlog(result);

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

        log('API result is $result', name: 'deleteHabit');

        await di.sl<FlutterLocalNotificationsPlugin>().cancel(habitId.hashCode);

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

  // @override
  // Future<Either<Failure, HabitlogResponse>> getHabitlogs(String habitId) async {
  //   if (await netWorkInfo.isConnected()) {
  // if(habitLogOffset != null){
  //     try {
  //       final result =
  //           await habitlogRemoteSource.getHabitlogs(habitlogOffset, habitId);

  //       log('API result is ${result.results}', name: 'getHabitLogs');
  //       if (habitlogOffset == 0) {
  //         await habitLocalSource.deleteAndinsertHabitlogs(result);
  //       } else {
  //         await habitLocalSource.insertHabitlogs(result);
  //       }

  //       final offset = API.offsetExtractor(result.next);

  //       habitlogOffset = offset;

  //       return Right(result);
  // } else {
  //TODO: return Left(NoMoreResultsFailure)
  // }
  //     } on UnAuthException {
  //       return Left(UnAuthFailure());
  //     } on UnknownException catch (error) {
  //       return Left(UnknownFailure(message: error.message));
  //     }
  //   } else {
  //     return Left(NoInternetFailure());
  //   }
  // }

  @override
  Future<Either<Failure, HabitlogResult>> insertHabitlog(String habitId) async {
    if (await netWorkInfo.isConnected()) {
      try {
        final result = await habitlogRemoteSource.insertHabitlog(habitId);

        log('API result is $result', name: 'insertHabitLog');

        await habitLocalSource.insertHabitlog(
          HabitResult(history: [
            History(
                habitId: result.habitId,
                habitlogId: result.habitlogId,
                doneAt: result.doneAt)
          ]),
        );

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

  @override
  Future<Either<Failure, HabitlogResponse>> getHabitlogs(String habitId) {
    throw UnimplementedError();
  }
}
