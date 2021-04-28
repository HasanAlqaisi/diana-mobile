import 'package:diana/core/api_helpers/api.dart';
import 'package:diana/core/mappers/date_to_ymd_string.dart';
import 'package:diana/core/mappers/failure_to_string.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/relations/task_with_subtasks/task_with_subtasks.dart';
import 'package:diana/data/database/relations/task_with_tags/task_with_tags.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/domain/usecases/task/edit_task_usecase.dart';
import 'package:diana/domain/usecases/task/get_tags_usecase.dart';
import 'package:diana/domain/usecases/task/insert_tag_usecase.dart';
import 'package:diana/domain/usecases/task/insert_task_usecase.dart';
import 'package:diana/presentation/task/widgets/subtask_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddTaskController extends GetxController {
  static AddTaskController get to => Get.find();

  final RequestTokenUsecase requestTokenUsecase;
  final GetTagsUseCase getTagsUseCase;
  final InsertTagUseCase insertTagUseCase;
  final InsertTaskUseCase insertTaskUseCase;
  final EditTaskUseCase editTaskUseCase;

  final formKey = GlobalKey<FormState>();
  final taskTitleController = TextEditingController();
  final noteController = TextEditingController();
  final tagController = TextEditingController();

  AddTaskController(
    this.requestTokenUsecase,
    this.getTagsUseCase,
    this.insertTagUseCase,
    this.insertTaskUseCase,
    this.editTaskUseCase,
  );

  var subtasks = <SubtaskField>[].obs;
  RxBool shouldRemind = false.obs;
  bool taskEditMode = false;
  TaskWithSubtasks taskData;
  TaskWithTags tagData;
  String taskName, note, tag;
  Rx<DateTime> date = DateTime(0).obs;
  Rx<DateTime> deadline = DateTime(0).obs;
  List<String> subtasksNames = [];
  var selectedTags = <String>[].obs;
  RxInt priority = 0.obs;
  // var selectedTags = <int>[].obs;

  @override
  void onInit() {
    super.onInit();

    API.doRequest(
      body: () async {
        return await getTagsUseCase();
      },
      failedBody: (failure) {
        Fluttertoast.showToast(msg: failureToString(failure));
      },
    );
  }

  void setTaskInfo(data) {
    if (data != null && data.isNotEmpty) {
      taskData = data[0] as TaskWithSubtasks;
      tagData = data[1] as TaskWithTags;
    }
    if (taskData != null && tagData != null) {
      taskEditMode = true;
      taskTitleController.text = taskData.task.name;
      noteController.text = taskData.task.note;
      taskData.subtasks.forEach((subtask) {
        subtasks.add(
          SubtaskField(
            key: UniqueKey(),
            text: subtask.name,
            index: subtasks.length,
            removeField: removeField,
          ),
        );
      });
      priority.value = taskData.task.priority;
      date.value = taskData.task.date ?? DateTime(0);
      shouldRemind.value = taskData.task.reminder != null ? true : false;
      if (shouldRemind.value) {
        date.value = DateTime(
          date.value.year,
          date.value.month,
          date.value.day,
          taskData.task.reminder.hour,
          taskData.task.reminder.minute,
        );
      }
      this.selectedTags.assignAll(tagData.tags.map((tag) => tag.name).toList());
      deadline.value = taskData.task.deadline ?? DateTime(0);
    } else {
      taskEditMode = false;
    }
  }

  void removeField(index) {
    subtasks.remove(index);
  }

  void updateSelectedTags({int index, String tagName}) {
    if (selectedTags.contains(tagName)) {
      print('onSelect: removing from the list...');

      print('removed? ' + selectedTags.remove(tagName).toString());
    } else {
      print('onSelect: adding to the list...');
      selectedTags.add(tagName);
    }
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
        if (!taskEditMode) {
          return await insertTaskUseCase(
            taskName,
            note,
            date.value?.year != 0
                ? date.value.toString().split(' ').first
                : null,
            selectedTags,
            subtasksNames,
            shouldRemind.value ? dateAndTimeToDjango(date.value) : null,
            deadline.value?.year != 0
                ? dateAndTimeToDjango(deadline.value)
                : null,
            priority.value,
            false,
          );
        } else {
          return await editTaskUseCase(
            taskData.task.id,
            taskName,
            note,
            date.value.year != 0
                ? date.value.toString().split(' ').first
                : null,
            selectedTags,
            subtasksNames,
            shouldRemind.value ? dateAndTimeToDjango(date.value) : null,
            deadline.value?.year != 0
                ? dateAndTimeToDjango(deadline.value)
                : null,
            priority.value,
            false,
          );
        }
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

  List<Widget> buildChips(List<TagData> tags) {
    List<Widget> chips = [];
    for (int i = 0; i < tags.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: this.selectedTags.contains(tags[i].name),
        label: Text(tags[i].name, style: TextStyle(color: Colors.white)),
        avatar: this.selectedTags.contains(tags[i].name)
            ? Icon(Icons.check, color: Colors.white)
            : null,
        pressElevation: 5,
        labelPadding: EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: Color(0xFFA687FF),
        selectedColor: Color(0xFFA687FF),
        onSelected: (bool isSelected) {
          updateSelectedTags(index: i, tagName: tags[i].name);
        },
      );
      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
    }
    return chips;
  }

  String dateFieldFormatter(DateTime date) {
    if (date?.year == 0) {
      return 'Choose a date';
    } else {
      return date.toString().split(' ').first;
    }
  }
}
