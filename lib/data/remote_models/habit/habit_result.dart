import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit_result.g.dart';

@JsonSerializable()
class HabitResult extends Equatable {
  @JsonKey(name: 'id')
  final String habitId;
  final String name;
  @JsonKey(nullable: true)
  final List<int> days;
  @JsonKey(nullable: true)
  final String time;
  @JsonKey(name: 'user')
  final String userId;

  HabitResult({
    this.habitId,
    this.name,
    this.days,
    this.time,
    this.userId,
  });

  factory HabitResult.fromJson(Map<String, dynamic> json) =>
      _$HabitResultFromJson(json);

  Map<String, dynamic> toJson() => _$HabitResultToJson(this);

  @override
  List<Object> get props {
    return [
      habitId,
      name,
      days,
      time,
      userId,
    ];
  }

  @override
  bool get stringify => true;
}
