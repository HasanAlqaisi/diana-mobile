import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habitlog_response.g.dart';

@JsonSerializable(explicitToJson: true)
class HabitlogResponse extends Equatable {
  final int count;

  final String next;

  final String previous;
  final List<HabitlogResult> results;

  HabitlogResponse({this.count, this.next, this.previous, this.results});

  factory HabitlogResponse.fromJson(Map<String, dynamic> json) =>
      _$HabitlogResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HabitlogResponseToJson(this);

  @override
  List<Object> get props => [count, next, previous, results];

  @override
  bool get stringify => true;
}
