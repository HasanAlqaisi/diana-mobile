import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String username;
  final String email;
  @JsonKey(nullable: true)
  final String birthdate;
  @JsonKey(name: 'daily_progress')
  final double dailyProgress;

  User(
      {this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.birthdate,
      this.dailyProgress});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object> get props {
    return [
      firstName,
      lastName,
      username,
      email,
      birthdate,
      dailyProgress,
    ];
  }
}
