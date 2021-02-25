import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';

part 'task_result.g.dart';

@JsonSerializable()
class TaskResult extends Equatable {
  @JsonKey(name: 'pk')
  final String taskId;
  @JsonKey(name: 'user')
  final String userId;
  @JsonKey(name: 'title')
  final String name;
  @JsonKey(nullable: true)
  final String note;
  final List<TagResult> tags;
  @JsonKey(name: 'checklist')
  final List<SubtaskResult> checkList;
  @JsonKey(nullable: true)
  final String date;
  @JsonKey(nullable: true)
  final String reminder;
  @JsonKey(nullable: true)
  final String deadline;
  @JsonKey(name: 'done_at', nullable: true)
  final String doneAt;
  final int priority;

  TaskResult({
    this.taskId,
    this.userId,
    this.name,
    this.note,
    this.tags,
    this.checkList,
    this.date,
    this.reminder,
    this.deadline,
    this.doneAt,
    this.priority,
  });

  factory TaskResult.fromJson(Map<String, dynamic> json) =>
      _$TaskResultFromJson(json);

  Map<String, dynamic> toJson() => _$TaskResultToJson(this);

  @override
  List<Object> get props {
    return [
      taskId,
      userId,
      name,
      note,
      tags,
      checkList,
      date,
      reminder,
      deadline,
      doneAt,
      priority,
    ];
  }

  @override
  bool get stringify => true;
}
