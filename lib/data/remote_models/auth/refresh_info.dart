import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'refresh_info.g.dart';

@JsonSerializable()
class RefreshInfo extends Equatable {
  final String access;
  final String refresh;

  RefreshInfo({
    this.access,
    this.refresh,
  });

  factory RefreshInfo.fromJson(Map<String, dynamic> json) =>
      _$RefreshInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshInfoToJson(this);

  @override
  List<Object> get props {
    return [access, refresh];
  }

  @override
  bool get stringify => true;
}
