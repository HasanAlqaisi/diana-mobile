import 'dart:convert';

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
