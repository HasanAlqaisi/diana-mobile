import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit_result.g.dart';

@JsonSerializable(explicitToJson: true)
class HabitResult extends Equatable {
  @JsonKey(name: 'id')
  final String habitId;
  final List<History> history;
  @JsonKey(name: 'title')
  final String name;

  final List<int> days;

  final String time;
  @JsonKey(name: 'user')
  final String userId;

  HabitResult({
    this.habitId,
    this.name,
    this.history,
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
      history,
    ];
  }
}

@JsonSerializable()
class History extends Equatable {
  @JsonKey(name: 'id')
  final String habitlogId;
  @JsonKey(name: 'done_at')
  final String doneAt;
  @JsonKey(name: 'habit')
  final String habitId;

  History({this.habitlogId, this.doneAt, this.habitId});

  factory History.fromJson(Map<String, dynamic> json) =>
      _$HistoryFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryToJson(this);

  @override
  List<Object> get props => [habitlogId, doneAt, habitId];
}
