import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasktag.g.dart';

@JsonSerializable()
class TaskTagResponse extends Equatable {
  final String id;
  @JsonKey(name: 'task')
  final String taskId;
  @JsonKey(name: 'tag')
  final String tagId;

  TaskTagResponse({this.id, this.taskId, this.tagId});

  factory TaskTagResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTagFromJson(json);

  Map<String, dynamic> toJson() => _$TaskTagToJson(this);

  @override
  List<Object> get props => [id, taskId, tagId];
}
