import 'dart:convert';

import 'package:diana/core/errors/days_errors.dart';
import 'package:diana/core/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  test(
      'should convert FieldsException to changePassFieldsFailure in a correct way',
      () {
    final changePassFieldsBody =
        json.decode(fixture('changepass_fields_error.json'));

    final changePassFieldsFailure = ChangePassFieldsFailure(
      pass1: ['This field is required.'],
    );

    final result =
        ChangePassFieldsFailure.fromFieldsException(changePassFieldsBody);

    expect(result, changePassFieldsFailure);
  });

  test('should convert FieldsException to UserFieldsFailure in a correct way',
      () {
    final userFieldsBody = json.decode(fixture('user_fields_error.json'));

    final userFieldsFailure = UserFieldsFailure(
      username: ['user with this username already exists.'],
      email: ['user with this username already exists.'],
    );

    final result = UserFieldsFailure.fromFieldsException(userFieldsBody);

    expect(result, userFieldsFailure);
  });

  test('should convert FieldsException to HabitFieldsFailure in a correct way',
      () {
    final habitFieldsBody = json.decode(fixture('habit_fields_error.json'));

    final habitFieldsFailure = HabitFieldsFailure(
      days: DaysError.fromJson(
        (((json.decode(
          fixture('habit_fields_error.json'),
        )) as Map<String, dynamic>))['days'],
      ),
    );

    final result = HabitFieldsFailure.fromFieldsException(habitFieldsBody);

    expect(result, habitFieldsFailure);
  });

  test(
      'should convert FieldsException to HabitlogFieldsFailure in a correct way',
      () {
    final habitlogFieldsBody =
        json.decode(fixture('habitlog_fields_error.json'));

    final habitlogFieldsFailure = HabitlogFieldsFailure(
      habitlogId: ['habit id not valid!'],
    );

    final result =
        HabitlogFieldsFailure.fromFieldsException(habitlogFieldsBody);

    expect(result, habitlogFieldsFailure);
  });

  test('should convert FieldsException to TaskFieldsFailure in a correct way',
      () {
    final taskFieldsBody = json.decode(fixture('task_fields_error.json'));

    final taskFieldsFailure = TaskFieldsFailure(
      name: ['name is not valid!'],
    );

    final result = TaskFieldsFailure.fromFieldsException(taskFieldsBody);

    expect(result, taskFieldsFailure);
  });

  test(
      'should convert FieldsException to TaskTagFieldsFailure in a correct way',
      () {
    final tasktagFieldsBody = json.decode(fixture('tasktag_fields_error.json'));

    final tasktagFieldsFailure = TaskTagFieldsFailure(
      taskId: ['task id not valid!'],
    );

    final result = TaskTagFieldsFailure.fromFieldsException(tasktagFieldsBody);

    expect(result, tasktagFieldsFailure);
  });

  test(
      'should convert FieldsException to SubtaskFieldsFailure in a correct way',
      () {
    final subtaskFieldsBody = json.decode(fixture('subtask_fields_error.json'));

    final subtaskFieldsFailure = SubtaskFieldsFailure(
      done: ['done shoud not be true!'],
    );

    final result = SubtaskFieldsFailure.fromFieldsException(subtaskFieldsBody);

    expect(result, subtaskFieldsFailure);
  });

  test('should convert FieldsException to TagFieldsFailure in a correct way',
      () {
    final tagFieldsBody = json.decode(fixture('tag_fields_error.json'));

    final tagFieldsFailure =
        TagFieldsFailure(color: ['Color is not in the range!']);

    final result = TagFieldsFailure.fromFieldsException(tagFieldsBody);

    expect(result, tagFieldsFailure);
  });

  test('should convert NonFieldsException to NonFieldsFailure in a correct way',
      () {
    final nonFieldsBody = json.decode(fixture('non_field_errors.json'));

    final nonFieldsFailure = NonFieldsFailure(
      errors: ['Unable to log in with provided credentials.'],
    );

    final result = NonFieldsFailure.fromNonFieldsException(nonFieldsBody);

    expect(result, nonFieldsFailure);
  });
}
