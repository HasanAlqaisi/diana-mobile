import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:diana/data/remote_models/auth/user.dart';

part 'login_info.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginInfo extends Equatable {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'refresh_token')
  final String refreshToken;
  final User user;

  LoginInfo({this.accessToken, this.refreshToken, this.user});

  factory LoginInfo.fromJson(Map<String, dynamic> json) =>
      _$LoginInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginInfoToJson(this);

  @override
  List<Object> get props => [accessToken, refreshToken, user];
}
