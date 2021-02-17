import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/data/remote_models/auth/login_info.dart';
import 'package:diana/data/remote_models/auth/refresh_info.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteSource {
  Future<User> registerUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String birthdate,
    String password,
  );

  Future<LoginInfo> loginUser(
    String username,
    String password,
  );

  Future<bool> logoutUser();

  Future<bool> changePass(String newPass1, String newPass2);

  Future<User> getUser();

  Future<User> editUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String birthdate,
    String password,
  );

  Future<bool> resetPass(String email);

  Future<RefreshInfo> requestToken(String refreshToken);
}

class AuthRemoteSourceImpl extends AuthRemoteSource {
  final http.Client client;

  AuthRemoteSourceImpl({this.client});

  Future<User> registerUser(
    String firstName,
    String lastName,
    String username,
    String email,
    String birthdate,
    String password,
  ) async {
    final response = await client.post(
      '$baseUrl/accounts/registration/',
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "birthdate": birthdate,
        "password": password,
      },
    );

    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<LoginInfo> loginUser(String username, String password) async {
    final response = await client.post(
      '$baseUrl/accounts/login/',
      body: {
        "username": username,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      return LoginInfo.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw NonFieldsException(message: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<bool> logoutUser() async {
    final response = await client.post(
      '$baseUrl/accounts/logout/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<bool> changePass(String newPass1, String newPass2) async {
    final response = await client.post(
      '$baseUrl/accounts/password/change/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "new_password1": newPass1,
        "new_password2": newPass2,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<User> editUser(String firstName, String lastName, String username,
      String email, String birthdate, String password) async {
    final response = await client.patch(
      '$baseUrl/accounts/user/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "email": email,
        "birthdate": birthdate,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<User> getUser() async {
    final response = await client.get(
      '$baseUrl/accounts/user/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<bool> resetPass(String email) async {
    final response = await client.post(
      '$baseUrl/accounts/password/reset/',
      body: {'email': email},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<RefreshInfo> requestToken(String refreshToken) async {
    final response = await client.post(
      '$baseUrl/accounts/token/refresh/',
      body: {
        "refresh": refreshToken,
      },
    );

    if (response.statusCode == 200) {
      return RefreshInfo.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException();
    }
  }
}
