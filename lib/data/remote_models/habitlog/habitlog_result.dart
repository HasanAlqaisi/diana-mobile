import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habitlog_result.g.dart';

@JsonSerializable()
class HabitlogResult extends Equatable {
  @JsonKey(name: 'id')
  final String habitlogId;
  @JsonKey(name: 'done_at')
  final String doneAt;
  @JsonKey(name: 'habit')
  final String habitId;

  HabitlogResult({
    this.habitlogId,
    this.doneAt,
    this.habitId,
  });

  factory HabitlogResult.fromJson(Map<String, dynamic> json) =>
      _$HabitlogResultFromJson(json);

  Map<String, dynamic> toJson() => _$HabitlogResultToJson(this);

  @override
  List<Object> get props => [habitlogId, doneAt, habitId];

  @override
  bool get stringify => true;
}
