import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tag_result.g.dart';

@JsonSerializable(explicitToJson: true)
class TagResult extends Equatable {
  final String? id;
  final String? name;
  final int? color;
  @JsonKey(name: 'user')
  final String? userId;

  TagResult({this.id, this.name, this.color, this.userId});

  factory TagResult.fromJson(Map<String, dynamic> json) =>
      _$TagResultFromJson(json);

  Map<String, dynamic> toJson() => _$TagResultToJson(this);

  @override
  List<Object?> get props => [id, name, color, userId];

  @override
  bool get stringify => true;
}
