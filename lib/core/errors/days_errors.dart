import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class DaysError extends Equatable {
  List<String> l0;
  List<String> l1;
  List<String> l2;
  List<String> l3;
  List<String> l4;
  List<String> l5;
  List<String> l6;

  DaysError({this.l0, this.l1, this.l2, this.l3, this.l4, this.l5, this.l6});

  DaysError.fromJson(Map<String, dynamic> json) {
    l0 = json['0']?.cast<String>() ?? null;
    l1 = json['1']?.cast<String>() ?? null;
    l2 = json['2']?.cast<String>() ?? null;
    l3 = json['3']?.cast<String>() ?? null;
    l4 = json['4']?.cast<String>() ?? null;
    l5 = json['5']?.cast<String>() ?? null;
    l6 = json['6']?.cast<String>() ?? null;
  }

  @override
  String toString() {
    return """
    0 = ${l0?.first},
    1 = ${l1?.first},
    2 = ${l2?.first},
    3 = ${l3?.first},
    4 = ${l4?.first},
    5 = ${l5?.first},
    6 = ${l6?.first},
    """;
  }

  @override
  List<Object> get props {
    return [
      l0,
      l1,
      l2,
      l3,
      l4,
      l5,
      l6,
    ];
  }
}
