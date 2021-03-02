import 'dart:convert';

import 'package:diana/core/constants/_constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/data/remote_models/subtask/subtask_response.dart';
import 'package:diana/data/remote_models/subtask/subtask_result.dart';
import 'package:http/http.dart' as http;

abstract class SubtaskRemoteSource {
  Future<SubtaskResponse> getSubtasks(String taskId, int offset);

  Future<SubtaskResult> insertSubtask(
    String name,
    bool isDone,
    String taskId,
  );

  Future<SubtaskResult> editSubtask(
    String subtaskId,
    String name,
    bool isDone,
    String taskId,
  );

  Future<bool> deleteSubtask(String subtaskId);
}

class SubtaskRemoteSourceImpl extends SubtaskRemoteSource {
  final http.Client client;

  SubtaskRemoteSourceImpl({this.client});

  @override
  Future<SubtaskResponse> getSubtasks(String taskId, int offset) async {
    final response = await client.get(
      '$baseUrl/subtask/?limit=10&offset=$offset',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
    );

    if (response.statusCode == 200) {
      return SubtaskResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<SubtaskResult> insertSubtask(
      String name, bool isDone, String taskId) async {
    final response = await client.post(
      '$baseUrl/subtask/',
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "title": name,
        "done": isDone,
        "task": taskId,
      },
    );

    if (response.statusCode == 201) {
      return SubtaskResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<SubtaskResult> editSubtask(
      String subtaskId, String name, bool isDone, String taskId) async {
    final response = await client.put(
      '$baseUrl/subtask/$subtaskId/',
      headers: {
        'Authorization': 'Bearer $kToken',
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "title": name,
        "done": isDone,
        "task": taskId,
      }),
    );

    if (response.statusCode == 200) {
      return SubtaskResult.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<bool> deleteSubtask(String subtaskId) async {
    final response = await client.delete(
      '$baseUrl/subtask/$subtaskId/',
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
