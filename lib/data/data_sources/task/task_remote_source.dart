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
    List<String> tags,
    List<String> checkList,
    String date,
    String reminder,
    String deadline,
    int priority,
    bool done,
  );

  Future<TaskResult> editTask(
    String taskId,
    String name,
    String note,
    List<String> tags,
    List<String> checkList,
    String date,
    String reminder,
    String deadline,
    int priority,
    bool done,
  );

  Future<TaskResult> makeTaskDone(String taskId);

  Future<bool> deleteTask(String taskId);
}

class TaskRemoteSourceImpl extends TaskRemoteSource {
  final http.Client client;

  TaskRemoteSourceImpl({this.client});

  @override
  Future<TaskResponse> getTasks(int offset) async {
    //TODO: Edit limit
    final response = await client.get(
      '$baseUrl/task/?limit=100&offset=$offset',
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
  Future<TaskResult> insertTask(
    String name,
    String note,
    List<String> tags,
    List<String> checkList,
    String date,
    String reminder,
    String deadline,
    int priority,
    bool done,
  ) async {
    print("""
            title: $name,
        note: $note,
        with_tags: $tags,
        with_subtasks: $checkList,
        date: $date,
        reminder: $reminder,
        deadline: $deadline,
        priority: $priority,
        done: $done,
    """);
    final response = await client.post('$baseUrl/task/',
        headers: {
          'Authorization': 'Bearer $kToken',
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
          {
            "title": name,
            "note": note,
            "with_tag": tags,
            "with_subtask": checkList,
            "date": date,
            "reminder": reminder,
            "deadline": deadline,
            "priority": priority,
            "done": done,
          },
        ));

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
  Future<TaskResult> editTask(
    String taskId,
    String name,
    String note,
    List<String> tags,
    List<String> checkList,
    String date,
    String reminder,
    String deadline,
    int priority,
    bool done,
  ) async {
    print("""task edition info: 
    title: $name
    note: $note
    tags: $tags
    checklist: $checkList
    date: $date
    reminder: $reminder
    deadline: $deadline
    priority: $priority
    done: $done""");

    final response = await client.put(
      '$baseUrl/task/$taskId/',
      headers: {
        'Authorization': 'Bearer $kToken',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(
        {
          "title": name,
          "note": note,
          "with_tag": tags,
          "with_subtask": checkList,
          "date": date,
          "reminder": reminder,
          "deadline": deadline,
          "priority": priority,
          "done": done
        },
      ),
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

  @override
  Future<TaskResult> makeTaskDone(String taskId) async {
    final response = await client.patch(
      '$baseUrl/task/$taskId/',
      headers: {
        'Authorization': 'Bearer $kToken',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(
        {
          "done": true,
        },
      ),
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
}
