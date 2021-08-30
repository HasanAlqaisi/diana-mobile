import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:diana/data/remote_models/subtask/subtask_result.dart';

part 'subtask_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SubtaskResponse extends Equatable {
  final int? count;

  final String? next;

  final String? previous;
  final List<SubtaskResult>? results;

  SubtaskResponse({this.count, this.next, this.previous, this.results});

  factory SubtaskResponse.fromJson(Map<String, dynamic> json) =>
      _$SubtaskResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubtaskResponseToJson(this);

  @override
  List<Object?> get props => [count, next, previous, results];

  @override
  bool get stringify => true;
}
