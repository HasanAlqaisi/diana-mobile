import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/domain/usecases/task/get_subtasks_usecase.dart';
import 'package:diana/domain/usecases/task/insert_task_usecase.dart';
import 'package:diana/domain/usecases/task/watch_tags_for_task.dart';
import 'package:diana/presentation/login/pages/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/domain/usecases/task/get_tags_usecase.dart';
import 'package:diana/domain/usecases/task/get_tasks_usecase.dart';
import 'package:diana/domain/usecases/task/watch_all_tags_usecase.dart';
import 'package:diana/domain/usecases/task/watch_all_tasks_usecase.dart';
import 'package:diana/domain/usecases/task/watch_completed_tasks_usecase.dart';
import 'package:diana/domain/usecases/task/watch_missed_tasks_usecase.dart';
import 'package:diana/domain/usecases/task/watch_today_tasks_usecase.dart';
import 'package:rxdart/rxdart.dart';

class TaskController extends GetxController {
  static TaskController get to => Get.find();

  final RequestTokenUsecase requestTokenUsecase;
  final GetTagsUseCase getTagsUseCase;
  final GetTasksUseCase getTasksUseCase;
  final WatchTodayTasksUseCase watchTodayTasksUseCase;
  final WatchAllTasksUseCase watchAllTasksUseCase;
  final WatchCompletedTasksUseCase watchCompletedTasksUseCase;
  final WatchMissedTasksUseCase watchMissedTasksUseCase;
  final WatchAllTagsUseCase watchAllTagsUseCase;
  final InsertTaskUseCase insertTaskUseCase;
  final WatchTagsForTaskUseCase watchTagsForTaskUseCase;
  final GetSubtasksUseCase getSubtasksUseCase;

  StreamController<TaskWithTags> _taskWithTagsController;
  Failure failure;
  RxBool isLongPressed = false.obs;
  RxString selectedTask = ''.obs;

  TaskController(
    this.requestTokenUsecase,
    this.getTagsUseCase,
    this.getTasksUseCase,
    this.watchTodayTasksUseCase,
    this.watchAllTasksUseCase,
    this.watchCompletedTasksUseCase,
    this.watchMissedTasksUseCase,
    this.watchAllTagsUseCase,
    this.insertTaskUseCase,
    this.watchTagsForTaskUseCase,
    this.getSubtasksUseCase,
  );

  @override
  void onInit() async {
    super.onInit();
    _taskWithTagsController = StreamController();

    print('[onInit] getting tasks');
    // (await getTagsUseCase()).fold((fail) async {
    //   print("FAIL happen => ${fail.runtimeType}");
    //   if (fail is UnAuthFailure) {
    //     final requestTokenResult = await requestTokenUsecase(kRefreshToken);
    //     requestTokenResult.fold((requestTokenFail) {
    //       if (requestTokenFail is UnAuthFailure) {
    //         Fluttertoast.showToast(msg: 'خلص الرفرش');
    //         Get.offAllNamed(LoginScreen.route);
    //       } else {
    //         Fluttertoast.showToast(msg: failureToString(fail));
    //       }
    //     }, (r) => null);
    //   } else {
    //     Fluttertoast.showToast(msg: failureToString(fail));
    //   }
    // }, (r) => null);

    await doRequest(() async {
      return await getTagsUseCase();
    });

    await doRequest(() async {
      return await getTasksUseCase();
    });

    // await doRequest(() async {
    //   return await getSubtasksUseCase(null);
    // });
  }

  Future<void> doRequest(Function body) async {
    (await body()).fold((fail) async {
      print("FAIL happen => ${fail.runtimeType}");
      if (fail is UnAuthFailure) {
        final requestTokenResult = await requestTokenUsecase(kRefreshToken);
        requestTokenResult.fold((requestTokenFail) {
          if (requestTokenFail is UnAuthFailure) {
            Fluttertoast.showToast(msg: 'خلص الرفرش');
            Get.offAllNamed(LoginScreen.route);
          } else {
            Fluttertoast.showToast(msg: failureToString(fail));
          }
        }, (r) => body());
      } else {
        Fluttertoast.showToast(msg: failureToString(fail));
      }
    }, (r) => null);
  }

  @override
  void onClose() async {
    super.onClose();
    _taskWithTagsController.close();
  }

  Future<void> addTask(String name, String note, String date, List<String> tags,
      String reminder, String deadline, int priority, bool done) async {
    await doRequest(() async {
      return await insertTaskUseCase(
          name, note, date, tags, reminder, deadline, priority, done);
    });
  }

  Stream<List<TaskWithSubtasks>> watchTodayTasks() {
    return watchTodayTasksUseCase();
  }

  Stream<List<TaskWithSubtasks>> watchAllTasks() {
    return watchAllTasksUseCase();
  }

  Stream<List<TaskWithSubtasks>> watchCompletedTasks() {
    return watchCompletedTasksUseCase();
  }

  Stream<List<TaskWithSubtasks>> watchMissedTasks() {
    return watchMissedTasksUseCase();
  }

  Stream<List<TagData>> watchAllTags() {
    return watchAllTagsUseCase();
  }

  Stream<TaskWithTags> watchTagsForTask(String taskId) {
    return watchTagsForTaskUseCase(taskId).asBroadcastStream();
  }
}
