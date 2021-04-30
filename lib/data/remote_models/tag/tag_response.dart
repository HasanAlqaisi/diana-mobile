import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';

part 'tag_response.g.dart';

@JsonSerializable(explicitToJson: true)
class TagResponse extends Equatable {
  final int count;

  final String next;

  final String previous;
  final List<TagResult> results;

  TagResponse({this.count, this.next, this.previous, this.results});

  factory TagResponse.fromJson(Map<String, dynamic> json) =>
      _$TagResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TagResponseToJson(this);

  @override
  List<Object> get props => [count, next, previous, results];

  @override
  bool get stringify => true;
}
