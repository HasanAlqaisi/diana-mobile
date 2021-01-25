import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'days.g.dart';

@JsonSerializable()
class Days extends Equatable {
  final List<int> days;

  Days({this.days});

  factory Days.fromJson(Map<String, dynamic> json) => _$DaysFromJson(json);

  Map<String, dynamic> toJson() => _$DaysToJson(this);

  @override
  List<Object> get props => [days];
}

class DaysConverter extends TypeConverter<Days, String> {
  @override
  Days mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    final days = json.decode(fromDb);

    return days.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(Days value) {
    if (value == null) {
      return null;
    }
    return json.encode(value.toJson());
  }
}
