import 'dart:convert';

import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/data/remote_models/tasktag/tasktag.dart';
import 'package:http/http.dart' as http;

abstract class TaskTagRemoteSource {
  Future<TaskTagResponse> insertTaskTag(String taskId, String tagId);

  Future<TaskTagResponse> editTaskTag(
    String id,
    String taskId,
    String tagId,
  );

  Future<bool> deleteTaskTag(String id);
}

class TaskTagRemoteSourceImpl extends TaskTagRemoteSource {
  final http.Client client;

  TaskTagRemoteSourceImpl({this.client});

  @override
  Future<TaskTagResponse> insertTaskTag(String taskId, String tagId) async {
    final response = await client.post(
      Uri.parse('$baseUrl/tasktag/'),
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "task": taskId,
        "tag": tagId,
      },
    );

    if (response.statusCode == 201) {
      return TaskTagResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<TaskTagResponse> editTaskTag(
      String id, String taskId, String tagId) async {
    final response = await client.put(
      Uri.parse('$baseUrl/tasktag/$id/'),
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "task": taskId,
        "tag": tagId,
      },
    );

    if (response.statusCode == 200) {
      return TaskTagResponse.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
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
  Future<bool> deleteTaskTag(String id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/tasktag/$id/'),
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
