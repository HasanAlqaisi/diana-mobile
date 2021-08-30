import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_response.g.dart';

@JsonSerializable(explicitToJson: true)
class TaskResponse extends Equatable {
  final int? count;

  final String? next;

  final String? previous;
  final List<TaskResult>? results;

  TaskResponse({this.count, this.next, this.previous, this.results});

  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TaskResponseToJson(this);

  @override
  List<Object?> get props => [count, next, previous, results];

  @override
  bool get stringify => true;
}
