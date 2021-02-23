import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subtask_result.g.dart';

@JsonSerializable(explicitToJson: true)
class SubtaskResult extends Equatable {
  final String id;
  final String name;
  final bool done;
  @JsonKey(name: 'task')
  final String taskId;

  SubtaskResult({this.id, this.name, this.done, this.taskId});

  factory SubtaskResult.fromJson(Map<String, dynamic> json) =>
      _$SubtaskResultFromJson(json);

  Map<String, dynamic> toJson() => _$SubtaskResultToJson(this);

  @override
  List<Object> get props => [id, name, done, taskId];

  @override
  bool get stringify => true;
}
