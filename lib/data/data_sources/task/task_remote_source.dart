import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/data/remote_models/task/task_response.dart';
import 'package:diana/data/remote_models/task/task_result.dart';
import 'package:http/http.dart' as http;

abstract class TaskRemoteSource {
  Future<TaskResponse> getTasks(int offset);

  Future<TaskResult> insertTask(
    String name,
    String note,
    String reminder,
    String deadline,
    int priority,
    bool done,
  );

  Future<TaskResult> editTask(
    String taskId,
    String name,
    String note,
    String reminder,
    String deadline,
    int priority,
    bool done,
  );

  Future<bool> deleteTask(String taskId);
}

class TaskRemoteSourceImpl extends TaskRemoteSource {
  final http.Client client;

  TaskRemoteSourceImpl({this.client});

  @override
  Future<TaskResponse> getTasks(int offset) async {
    final response = await client.get(
      '$baseUrl/task/?limit=10&offset=$offset',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
    );

    if (response.statusCode == 200) {
      return TaskResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<TaskResult> insertTask(String name, String note, String reminder,
      String deadline, int priority, bool done) async {
    final response = await client.post(
      '$baseUrl/task/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "name": name,
        "note": note,
        "reminder": reminder,
        "deadline": deadline,
        "priority": priority,
        "done": done,
      },
    );

    if (response.statusCode == 201) {
      return TaskResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<TaskResult> editTask(String taskId, String name, String note,
      String reminder, String deadline, int priority, bool done) async {
    final response = await client.put(
      '$baseUrl/task/$taskId/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "name": name,
        "note": note,
        "reminder": reminder,
        "deadline": deadline,
        "priority": priority,
        "done": done,
      },
    );

    if (response.statusCode == 200) {
      return TaskResult.fromJson(json.decode(response.body));
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
  Future<bool> deleteTask(String taskId) async {
    final response = await client.delete(
      '$baseUrl/task/$taskId/',
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
