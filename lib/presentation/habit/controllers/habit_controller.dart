import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/data/database/relations/habit_with_habitlogs/habit_with_habitlogs.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/domain/usecases/habit/edit_habit_usecase.dart';
import 'package:diana/domain/usecases/habit/get_habit_logs.dart';
import 'package:diana/domain/usecases/habit/get_habits_usecase.dart';
import 'package:diana/domain/usecases/habit/insert_habit_usecase.dart';
import 'package:diana/domain/usecases/habit/watch_all_habits_usecase.dart';
import 'package:diana/domain/usecases/habit/watch_today_habits_usecase.dart';
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

  Stream<Future<List<HabitWitLogsWithDays>>> watchAllHabits() {
    return watchAllHabitsUseCase();
  }

  Stream<Future<List<HabitWitLogsWithDays>>> watchTodayHabits(int day) {
    return watchTodayHabitsUseCase(day);
  }
}
