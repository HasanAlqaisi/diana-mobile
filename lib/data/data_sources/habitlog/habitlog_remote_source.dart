import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_response.dart';
import 'package:diana/data/remote_models/habitlog/habitlog_result.dart';
import 'package:http/http.dart' as http;

abstract class HabitlogRemoteSource {
  Future<HabitlogResponse> getHabitlogs(
    int offset,
    String habitId,
  );

  Future<HabitlogResult> insertHabitlog(
    String habitId,
  );
}

class HabitlogRemoteSourceImpl extends HabitlogRemoteSource {
  final http.Client client;

  HabitlogRemoteSourceImpl({this.client});

  @override
  Future<HabitlogResponse> getHabitlogs(int offset, String habitId) async {
    final response = await client.get(
      '$baseUrl/habitlog/?limit=10&offset=$offset&habit=$habitId/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
    );

    if (response.statusCode == 200) {
      return HabitlogResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<HabitlogResult> insertHabitlog(String habitId) async {
    final response = await client.post(
      '$baseUrl/habitlog/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "habit": habitId,
      },
    );

    if (response.statusCode == 201) {
      return HabitlogResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }
}
