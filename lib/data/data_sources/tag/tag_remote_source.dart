import 'dart:convert';

import 'package:diana/core/constants/constants.dart';
import 'package:diana/core/errors/exception.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';
import 'package:http/http.dart' as http;

abstract class TagRemoteSource {
  Future<TagResponse> getTags(int? offset);
  Future<TagResult> insertTags(String name, int color);
  Future<TagResult> editTag(String id, String name, int color);
  Future<bool> deleteTag(String id);
}

class TagRemoteSourceImpl extends TagRemoteSource {
  final http.Client? client;

  TagRemoteSourceImpl({this.client});

  @override
  Future<TagResponse> getTags(int? offset) async {
    final response = await client!.get(
      Uri.parse('$baseUrl/tag/?limit=100&offset=$offset'),
      headers: {
        'Authorization': 'Bearer $kToken',
      },
    );

    if (response.statusCode == 200) {
      return TagResponse.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<TagResult> insertTags(String name, int color) async {
    final response = await client!.post(
      Uri.parse('$baseUrl/tag/'),
      headers: {
        'Authorization': 'Bearer $kToken',
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        "name": name,
        "color": color,
      }),
    );

    if (response.statusCode == 201) {
      return TagResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));
    } else if (response.statusCode == 401) {
      throw UnAuthException();
    } else if (response.statusCode == 400) {
      throw FieldsException(body: response.body);
    } else {
      throw UnknownException(message: response.body);
    }
  }

  @override
  Future<TagResult> editTag(String id, String name, int color) async {
    final response = await client!.put(
      Uri.parse('$baseUrl/tag/$id/'),
      headers: {
        'Authorization': 'Bearer $kToken',
      },
      body: {
        "name": name,
        "color": color,
      },
    );

    if (response.statusCode == 200) {
      return TagResult.fromJson(json.decode(utf8.decode(response.bodyBytes)));
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
  Future<bool> deleteTag(String id) async {
    final response = await client!.delete(
      Uri.parse('$baseUrl/tag/$id/'),
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
