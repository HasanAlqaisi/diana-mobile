import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit_response.g.dart';

@JsonSerializable(explicitToJson: true)
class HabitResponse extends Equatable {
  final int count;
  @JsonKey(nullable: true)
  final String next;
  @JsonKey(nullable: true)
  final String previous;
  final List<HabitResult> results;

  HabitResponse({this.count, this.next, this.previous, this.results});

  factory HabitResponse.fromJson(Map<String, dynamic> json) =>
      _$HabitResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HabitResponseToJson(this);

  @override
  List<Object> get props => [count, next, previous, results];
}
