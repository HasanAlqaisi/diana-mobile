import 'package:equatable/equatable.dart';

abstract class Failure {}

class UnAuthFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class UnknownFailure extends Equatable implements Failure {
  final String message;

  UnknownFailure({this.message});

  @override
  List<Object> get props => [message];
}

class ChangePassFieldsFailure extends Equatable implements Failure {
  final List<String> pass1;
  final List<String> pass2;

  ChangePassFieldsFailure({this.pass1, this.pass2});

  factory ChangePassFieldsFailure.fromFieldsException(
      Map<String, dynamic> body) {
    return ChangePassFieldsFailure(
      pass1: body['new_password1']?.cast<String>() as List<String> ?? null,
      pass2: body['new_password2']?.cast<String>() as List<String> ?? null,
    );
  }

  @override
  List<Object> get props => [pass1, pass2];
}

class NoInternetFailure extends Equatable implements Failure {
  @override
  List<Object> get props => [];
}

class UserFieldsFailure extends Equatable implements Failure {
  final List<String> firstName;
  final List<String> lastName;
  final List<String> username;
  final List<String> email;
  final List<String> birthdate;
  final List<String> password;

  UserFieldsFailure({
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.birthdate,
    this.password,
  });

  factory UserFieldsFailure.fromFieldsException(Map<String, dynamic> body) {
    return UserFieldsFailure(
      firstName: body['first_name']?.cast<String>() as List<String> ?? null,
      lastName: body['last_name']?.cast<String>() as List<String> ?? null,
      username: body['username']?.cast<String>() as List<String> ?? null,
      email: body['email']?.cast<String>() as List<String> ?? null,
      birthdate: body['birthdate']?.cast<String>() as List<String> ?? null,
      password: body['password']?.cast<String>() as List<String> ?? null,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
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
  final List<String> errors;

  NonFieldsFailure({this.errors});

  factory NonFieldsFailure.fromNonFieldsException(Map<String, dynamic> body) {
    return NonFieldsFailure(
        errors: body['non_field_errors']?.cast<String>() as List<String>);
  }

  @override
  List<Object> get props => [errors];
}
