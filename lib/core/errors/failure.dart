import 'package:equatable/equatable.dart';

import 'package:diana/core/errors/days_errors.dart';

abstract class Failure {}

class UnAuthFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class UnknownFailure extends Equatable implements Failure {
  final String? message;

  UnknownFailure({this.message});

  @override
  List<Object?> get props => [message];
}

class NotFoundFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class ChangePassFieldsFailure extends Equatable implements Failure {
  final List<String>? pass1;
  final List<String>? pass2;

  ChangePassFieldsFailure({this.pass1, this.pass2});

  factory ChangePassFieldsFailure.fromFieldsException(
      Map<String, dynamic> body) {
    return ChangePassFieldsFailure(
      pass1: body['new_password1']?.cast<String>() as List<String>? ?? null,
      pass2: body['new_password2']?.cast<String>() as List<String>? ?? null,
    );
  }

  @override
  List<Object?> get props => [pass1, pass2];
}

class NoInternetFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class UserFieldsFailure extends Equatable implements Failure {
  final List<String>? firstName;
  final List<String>? lastName;
  final List<String>? username;
  final List<String>? email;
  final List<String>? birthdate;
  final List<String>? password;
  final List<String>? image;

  UserFieldsFailure(
      {this.firstName,
      this.lastName,
      this.username,
      this.email,
      this.birthdate,
      this.password,
      this.image});

  factory UserFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return UserFieldsFailure(
      firstName: body['first_name']?.cast<String>() as List<String>? ?? null,
      lastName: body['last_name']?.cast<String>() as List<String>? ?? null,
      username: body['username']?.cast<String>() as List<String>? ?? null,
      email: body['email']?.cast<String>() as List<String>? ?? null,
      birthdate: body['birthdate']?.cast<String>() as List<String>? ?? null,
      password: body['password']?.cast<String>() as List<String>? ?? null,
      image: body['image']?.cast<String>() as List<String>? ?? null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      firstName,
      lastName,
      username,
      email,
      birthdate,
      password,
    ];
  }
}

class NonFieldsFailure extends Equatable implements Failure {
  final List<String>? errors;

  NonFieldsFailure({this.errors});

  factory NonFieldsFailure.fromNonFieldsException(Map<String, dynamic> body) {
    return NonFieldsFailure(
        errors: body['non_field_errors']?.cast<String>() as List<String>?);
  }

  @override
  List<Object?> get props => [errors];
}

class HabitFieldsFailure extends Equatable implements Failure {
  final List<String>? name;
  final DaysError? days;
  final List<String>? time;

  HabitFieldsFailure({
    this.name,
    this.days,
    this.time,
  });

  factory HabitFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return HabitFieldsFailure(
      name: body['title']?.cast<String>() as List<String>? ?? null,
      days: body['days'] != null ? DaysError.fromJson(body['days']) : null,
      time: body['time']?.cast<String>() as List<String>? ?? null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [name, days, time];
}

class HabitlogFieldsFailure extends Equatable implements Failure {
  final List<String>? habitlogId;

  HabitlogFieldsFailure({
    this.habitlogId,
  });

  factory HabitlogFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return HabitlogFieldsFailure(
      habitlogId: body['habit']?.cast<String>() as List<String>? ?? null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [habitlogId];
}

class SubtaskFieldsFailure extends Equatable implements Failure {
  final List<String>? id;
  final List<String>? name;
  final List<String>? done;
  final List<String>? task;

  SubtaskFieldsFailure({
    this.id,
    this.name,
    this.done,
    this.task,
  });

  factory SubtaskFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return SubtaskFieldsFailure(
      id: body['id']?.cast<String>() as List<String>? ?? null,
      name: body['name']?.cast<String>() as List<String>? ?? null,
      done: body['done']?.cast<String>() as List<String>? ?? null,
      task: body['task']?.cast<String>() as List<String>? ?? null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, done, task];
}

class TagFieldsFailure extends Equatable implements Failure {
  final List<String>? id;
  final List<String>? name;
  final List<String>? color;
  final List<String>? user;

  TagFieldsFailure({
    this.id,
    this.name,
    this.color,
    this.user,
  });

  factory TagFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return TagFieldsFailure(
      id: body['id']?.cast<String>() as List<String>? ?? null,
      name: body['name']?.cast<String>() as List<String>? ?? null,
      color: body['color']?.cast<String>() as List<String>? ?? null,
      user: body['user']?.cast<String>() as List<String>? ?? null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, color, user];
}

class TaskFieldsFailure extends Equatable implements Failure {
  final List<String>? name;
  final List<String>? note;
  final List<String>? date;
  final List<String>? reminder;
  final List<String>? deadline;
  final List<String>? priority;
  final List<String>? done;
  final List<String>? nonFields;

  TaskFieldsFailure({
    this.name,
    this.note,
    this.date,
    this.reminder,
    this.deadline,
    this.priority,
    this.done,
    this.nonFields,
  });

  factory TaskFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return TaskFieldsFailure(
        name: body['title']?.cast<String>() as List<String>? ?? null,
        note: body['note']?.cast<String>() as List<String>? ?? null,
        date: body['date']?.cast<String>() as List<String>? ?? null,
        reminder: body['reminder']?.cast<String>() as List<String>? ?? null,
        deadline: body['deadline']?.cast<String>() as List<String>? ?? null,
        priority: body['priority']?.cast<String>() as List<String>? ?? null,
        done: body['done']?.cast<String>() as List<String>? ?? null,
        nonFields:
            body['non_field_errors']?.cast<String>() as List<String>? ?? null);
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      name,
      note,
      reminder,
      deadline,
      priority,
      done,
      nonFields,
    ];
  }
}

class TaskTagFieldsFailure extends Equatable implements Failure {
  final List<String>? id;
  final List<String>? taskId;
  final List<String>? tagId;

  TaskTagFieldsFailure({
    this.id,
    this.taskId,
    this.tagId,
  });

  factory TaskTagFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return TaskTagFieldsFailure(
      id: body['id']?.cast<String>() as List<String>? ?? null,
      taskId: body['task']?.cast<String>() as List<String>? ?? null,
      tagId: body['tag']?.cast<String>() as List<String>? ?? null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, taskId, tagId];
}

class NoMoreResultsFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}
