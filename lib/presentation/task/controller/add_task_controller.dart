import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/domain/usecases/task/get_tags_usecase.dart';
import 'package:diana/domain/usecases/task/insert_tag_usecase.dart';
import 'package:diana/domain/usecases/task/insert_task_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:diana/presentation/task/pages/add_task_screen.dart';

class AddTaskController extends GetxController {
  static AddTaskController get to => Get.find();

  final RequestTokenUsecase requestTokenUsecase;
  final GetTagsUseCase getTagsUseCase;
  final InsertTagUseCase insertTagUseCase;
  final InsertTaskUseCase insertTaskUseCase;

  AddTaskController(this.requestTokenUsecase, this.getTagsUseCase,
      this.insertTagUseCase, this.insertTaskUseCase);

  RxList<dynamic> subtasks = [].obs;
  RxBool shouldRemind = false.obs;
  RxString reminderTime = ''.obs, startingDate = ''.obs, deadlineDate = ''.obs;
  String taskName, note, tag;
  var date = DateTime(2021).obs;
  List<String> subtasksNames = [];
  var tags = List<String>().obs;
  RxInt priority = 0.obs;
  var selectedTags = <int>[];

  @override
  void onInit() {
    API.doRequest(
      body: () async {
        return await getTagsUseCase();
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
    super.onInit();
  }

  void updateSelectedTags({int index}) {
    if (selectedTags.contains(index)) {
      selectedTags.remove(index);
    } else {
      selectedTags.add(index);
    }
    update();
  }

  void onTagPlusClicked() {
    API.doRequest(
      body: () async {
        return await insertTagUseCase(tag, priority.value);
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  Future<void> onTaskPlusClicked() async {
    await API.doRequest(
      body: () async {
        return await insertTaskUseCase(
          taskName,
          note,
          startingDate.value,
          tags,
          subtasksNames,
          reminderTime.value,
          deadlineDate.value,
          priority.value,
          false,
        );
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
      successBody: () {
        print('Geting back');
        Get.back();
      },
    );
  }
  // RxInt subtaskFields = 0.obs;
}
