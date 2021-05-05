import 'dart:convert';

import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/data/remote_models/habit/habit_response.dart';
import 'package:diana/data/remote_models/habit/habit_result.dart';
import 'package:http/http.dart' as http;

abstract class HabitRemoteSource {
  Future<HabitResponse> getHabits(int offset);

  Future<HabitResult> insertHabit(
    String name,
    List<int> days,
    String time,
  );

  Future<HabitResult> editHabit(
    String habitId,
    String name,
    List<int> days,
    String time,
  );

  Future<bool> deleteHabit(String habitId);
}

class HabitRemoteSourceImpl extends HabitRemoteSource {
  final http.Client client;

  HabitRemoteSourceImpl({this.client});

  @override
  Future<HabitResponse> getHabits(int offset) async {
    final response = await client.get(
      Uri.parse('$baseUrl/habit/?limit=100&offset=$offset'),
      headers: {
        'Authorization': 'Bearer $kToken',
      },
    );

    if (response.statusCode == 200) {
      return HabitResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<HabitResult> insertHabit(
      String name, List<int> days, String time) async {
    final response = await client.post(
      Uri.parse('$baseUrl/habit/'),
      headers: {
        'Authorization': 'Bearer $kToken',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "title": name,
        "days": days,
        "time": time,
      }),
    );

    if (response.statusCode == 201) {
      return HabitResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<HabitResult> editHabit(
      String habitId, String name, List<int> days, String time) async {
    final response = await client.put(
      Uri.parse('$baseUrl/habit/$habitId/'),
      headers: {
        'Authorization': 'Bearer $kToken',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "title": name,
        "days": days,
        "time": time,
      }),
    );

    if (response.statusCode == 200) {
      return HabitResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<bool> deleteHabit(String habitId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/habit/$habitId/'),
      headers: {
        'Authorization': 'Bearer $kToken',
      },
    );

    if (response.statusCode == 204) {
      return true;
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException(message: response.body);
    }
  }
}
