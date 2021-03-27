import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/constants/enums.dart';
import 'package:diana/core/date/date_helper.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/domain/usecases/auth/watch_user_usecase.dart';
import 'package:diana/domain/usecases/habit/edit_habit_usecase.dart';
import 'package:diana/domain/usecases/habit/get_habit_logs.dart';
import 'package:diana/domain/usecases/habit/get_habits_usecase.dart';
import 'package:diana/domain/usecases/habit/insert_habit_usecase.dart';
import 'package:diana/domain/usecases/habit/watch_all_habits_usecase.dart';
import 'package:diana/domain/usecases/habit/watch_today_habits_usecase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class HabitController extends GetxController {
  static HabitController get to => Get.find();

  final RequestTokenUsecase requestTokenUsecase;
  final GetHabitsUseCase getHabitsUseCase;
  final GetHabitLogsUseCase getHabitLogsUseCase;
  final WatchTodayHabitUseCase watchTodayHabitsUseCase;
  final WatchAllHabitUseCase watchAllHabitsUseCase;
  final InsertHabitUseCase insertHabitUseCase;
  final EditHabitUseCase editHabitUseCase;
  final WatchUserUsecase watchUserUsecase;

  Failure failure;
  RxBool isLongPressed = false.obs;
  RxString selectedHabit = ''.obs;

  HabitController(
    this.requestTokenUsecase,
    this.insertHabitUseCase,
    this.editHabitUseCase,
    this.getHabitsUseCase,
    this.getHabitLogsUseCase,
    this.watchTodayHabitsUseCase,
    this.watchAllHabitsUseCase,
    this.watchUserUsecase,
  );

  @override
  void onInit() async {
    super.onInit();
    await API.doRequest(
      body: () async {
        return await getHabitsUseCase();
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  HabitDoneDays getLogsInCurrentWeekRange(HabitWitLogsWithDays habit) {
    final firstDayOfWeek = DateHelper.getFirstDayOfWeek(DateTime.now());
    final lastDayOfWeek = DateHelper.getLastDayOfWeek(DateTime.now());
    HabitDoneDays doneDays = HabitDoneDays();
    habit.habitLogs.forEach((habitLog) {
      // Should be same (0) or After (positive)
      int compareToFirstDayOfWeek = habitLog.doneAt.compareTo(firstDayOfWeek);
      // Should be same (0) or Before (negative)
      int compareToLastDayOfWeek = habitLog.doneAt.compareTo(lastDayOfWeek);

      if (compareToFirstDayOfWeek >= 0 && compareToLastDayOfWeek <= 0) {
        final doneWeekDay = habitLog.doneAt.weekday;
        final djangoDoneWeekDay = DateHelper.mapWeekDayToDjangoWay(doneWeekDay);
        doneDays.weekDays.add(djangoDoneWeekDay);
      }
    });
    return doneDays;
  }

  Color dayColor(int djangoWeekDay, HabitWitLogsWithDays habit) {
    if (habit.days?.dayZero == djangoWeekDay ||
        habit.days?.dayOne == djangoWeekDay ||
        habit.days?.dayTwo == djangoWeekDay ||
        habit.days?.dayThree == djangoWeekDay ||
        habit.days?.dayFour == djangoWeekDay ||
        habit.days?.dayFive == djangoWeekDay ||
        habit.days?.daySix == djangoWeekDay) {
      if (habit.doneDays.weekDays.contains(djangoWeekDay)) {
        return Colors.blue;
      } else {
        final djangoCurrentWeekDay = DateTime.now().weekday - 1;
        if (djangoCurrentWeekDay < djangoWeekDay) {
          return Colors.black;
        } else {
          return Colors.orange;
        }
      }
    } else {
      return Colors.grey;
    }
  }

  Stream<Future<List<HabitWitLogsWithDays>>> watchAllHabits() {
    return watchAllHabitsUseCase();
  }

  Stream<Future<List<HabitWitLogsWithDays>>> watchTodayHabits(int day) {
    return watchTodayHabitsUseCase(day);
  }

  Stream<UserData> watchUser() {
    return watchUserUsecase();
  }

  Stream<Future<List<HabitWitLogsWithDays>>> watch({HabitType habitType}) {
    if (habitType == HabitType.today) {
      final weekday = DateTime.now().weekday;
      final djangoWeekDay = DateHelper.mapWeekDayToDjangoWay(weekday);
      return watchTodayHabits(djangoWeekDay);
    } else {
      return watchAllHabits();
    }
  }
}
