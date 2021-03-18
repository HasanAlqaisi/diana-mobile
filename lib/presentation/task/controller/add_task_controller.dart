import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/domain/usecases/task/get_tags_usecase.dart';
import 'package:diana/domain/usecases/task/insert_tag_usecase.dart';
import 'package:diana/domain/usecases/task/insert_task_usecase.dart';
import 'package:diana/presentation/task/widgets/subtask_field.dart';
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

  final formKey = GlobalKey<FormState>();

  AddTaskController(this.requestTokenUsecase, this.getTagsUseCase,
      this.insertTagUseCase, this.insertTaskUseCase);

  var subtasks = <SubtaskField>[].obs;
  RxBool shouldRemind = false.obs;
  RxString reminderTime = ''.obs, startingDate = ''.obs, deadlineDate = ''.obs;
  String taskName, note, tag;
  var date = DateTime(2021).obs;
  List<String> subtasksNames = [];
  var tags = <String>[].obs;
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

  void removeField(index) {
    subtasks.remove(index);
  }

  void updateSelectedTags({int index, String tagName}) {
    if (selectedTags.contains(index)) {
      selectedTags.remove(index);
      tags.removeAt(index);
    } else {
      selectedTags.add(index);
      tags.add(tagName);
    }
    update();
  }

  Future<void> onTagPlusClicked() async {
    return await API.doRequest(
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
          startingDate.value != null && startingDate.value.isNotEmpty
              ? startingDate.value
              : null,
          tags,
          subtasksNames,
          startingDate.value != null && reminderTime.value.isNotEmpty
              ? reminderTime.value
              : null,
          startingDate.value != null && deadlineDate.value.isNotEmpty
              ? deadlineDate.value
              : null,
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
