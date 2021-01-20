import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_result.g.dart';

@JsonSerializable()
class TaskResult extends Equatable {
  @JsonKey(name: 'user')
  final String userId;
  final String name;
  @JsonKey(nullable: true)
  final String note;
  final List<String> tags;
  @JsonKey(nullable: true)
  final String reminder;
  @JsonKey(nullable: true)
  final String deadline;
  @JsonKey(nullable: true)
  final String doneAt;
  final int priority;

  TaskResult({
    this.userId,
    this.name,
    this.note,
    this.tags,
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
      userId,
      name,
      note,
      tags,
      reminder,
      deadline,
      doneAt,
      priority,
    ];
  }
}
