import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/domain/usecases/auth/get_user_usecase.dart';
import 'package:diana/domain/usecases/auth/watch_user_usecase.dart';
import 'package:diana/domain/usecases/task/delete_task_usecase.dart';
import 'package:diana/domain/usecases/task/edit_subtask_usecase.dart';
import 'package:diana/domain/usecases/task/edit_task_usecase.dart';
import 'package:diana/domain/usecases/task/get_subtasks_usecase.dart';
import 'package:diana/domain/usecases/task/insert_task_usecase.dart';
import 'package:diana/domain/usecases/task/make_task_done_usecase.dart';
import 'package:diana/domain/usecases/task/watch_tags_for_task.dart';
import 'package:diana/presentation/login/pages/login_screen.dart';
import 'package:diana/presentation/profile/pages/profile_screen.dart';
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
  final EditTaskUseCase editTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final MakeTaskDoneUseCase makeTaskDoneUseCase;
  final EditSubTaskUseCase editSubTaskUseCase;
  final GetUserUsecase getUserUsecase;
  final WatchUserUsecase watchUserUsecase;

  StreamController<TaskWithTags> _taskWithTagsController;
  Failure failure;
  RxBool isLongPressed = false.obs;
  RxString selectedTask = ''.obs;
  var tags = List<String>().obs;
  var selectedTags = <int>[];

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
    this.editTaskUseCase,
    this.deleteTaskUseCase,
    this.makeTaskDoneUseCase,
    this.editSubTaskUseCase,
    this.getUserUsecase,
    this.watchUserUsecase,
  );

  @override
  void onInit() async {
    super.onInit();
    _taskWithTagsController = StreamController();

    print('[onInit] getting tasks');

    await API.doRequest(
      body: () async {
        return await getUserUsecase();
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
      successBody: () async {
        await API.doRequest(
          body: () async {
            return await getTagsUseCase();
          },
          failedBody: (failure) {
            Fluttertoast.showToast(msg: failureToString(failure));
          },
          successBody: () async {
            await API.doRequest(
              body: () async {
                return await getTasksUseCase();
              },
              failedBody: (failure) {
                Fluttertoast.showToast(msg: failureToString(failure));
              },
            );
          },
        );
      },
    );
  }

  void onProfileImageTapped() {
    Get.toNamed(ProfileScreen.route);
  }

  @override
  void onClose() async {
    super.onClose();
    _taskWithTagsController.close();
  }

  void updateSelectedTags({bool isSelected, int index, int length}) {
    if (selectedTags.contains(index)) {
      selectedTags.remove(index);
    } else {
      selectedTags.add(index);
    }
    update();
  }

  Future<void> addTask(
    String name,
    String note,
    String date,
    List<String> tags,
    List<String> checklist,
    String reminder,
    String deadline,
    int priority,
    bool done,
  ) async {
    await API.doRequest(
      body: () async {
        return await insertTaskUseCase(name, note, date, tags, checklist,
            reminder, deadline, priority, done);
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  Future<void> editTask(
    String taskId,
    String name,
    String note,
    String date,
    List<String> tags,
    List<String> checklist,
    String reminder,
    String deadline,
    int priority,
    bool done,
  ) async {
    await API.doRequest(
      body: () async {
        return await editTaskUseCase(taskId, name, note, date, tags, checklist,
            reminder, deadline, priority, done);
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  Future<void> makeTaskDone(String taskId) async {
    await API.doRequest(
      body: () async {
        return await makeTaskDoneUseCase(taskId);
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  Future<void> onDeleteTaskClicked(String taskId) async {
    await API.doRequest(
      body: () async {
        return await deleteTaskUseCase(taskId);
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  Future<void> changeSubtaskState(SubTaskData subTask) async {
    await API.doRequest(
      body: () async {
        return await editSubTaskUseCase(
            subTask.id, subTask.name, !subTask.done, subTask.taskId);
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  Stream<UserData> watchUser() {
    return watchUserUsecase();
  }

  Stream<List<TaskWithSubtasks>> watchTodayTasks(List<String> tags) {
    return watchTodayTasksUseCase(tags);
  }

  Stream<List<TaskWithSubtasks>> watchAllTasks(List<String> tags) {
    return watchAllTasksUseCase(tags);
  }

  Stream<List<TaskWithSubtasks>> watchCompletedTasks(List<String> tags) {
    return watchCompletedTasksUseCase(tags);
  }

  Stream<List<TaskWithSubtasks>> watchMissedTasks(List<String> tags) {
    return watchMissedTasksUseCase(tags);
  }

  Stream<List<TagData>> watchAllTags() {
    return watchAllTagsUseCase();
  }

  Stream<TaskWithTags> watchTagsForTask(String taskId) {
    return watchTagsForTaskUseCase(taskId).asBroadcastStream();
  }
}
