import 'package:diana/core/constants/constants.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:drift/drift.dart';

import 'package:diana/data/database/models/user/user_dao.dart';
import 'package:diana/data/remote_models/auth/user.dart';

abstract class AuthLocalSource {
  Stream<UserData> watchUser(String? userId);

  Future<void> insertUser(User? user);

  Future<void> deleteUser(User user);

  Future<void> cacheUserId(String? userId);

  Future<void> deleteUserId();

  Future<void> cacheToken(String? token);

  Future<void> deleteToken();

  Future<void> cacheRefreshToken(String? refreshToken);

  Future<void> deleteRefreshToken();

  Future<String?> getUserId();

  Future<String?> getToken();

  Future<String?> getRefreshToken();
}

class AuthLocalSourceImpl extends AuthLocalSource {
  final UserDao? userDao;
  final FlutterSecureStorage? storage;

  AuthLocalSourceImpl({
    this.userDao,
    this.storage,
  });

  @override
  Future<void> deleteUser(User user) {
    try {
      return userDao!.deleteUser(user);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> insertUser(User? user) {
    try {
      return userDao!.insertUser(user!);
    } on InvalidDataException {
      rethrow;
    }
  }

  @override
  Future<void> cacheRefreshToken(String? refreshToken) async {
    kRefreshToken = refreshToken;
    return await storage!.write(key: refreshKey, value: refreshToken);
  }

  @override
  Future<void> cacheToken(String? token) async {
    kToken = token;
    return await storage!.write(key: tokenKey, value: token);
  }

  @override
  Future<void> cacheUserId(String? userId) async {
    kUserId = userId;
    return await storage!.write(key: userIdKey, value: userId);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await storage!.read(key: refreshKey);
  }

  @override
  Future<String?> getToken() async {
    return await storage!.read(key: tokenKey);
  }

  @override
  Future<String?> getUserId() async {
    return await storage!.read(key: userIdKey);
  }

  @override
  Stream<UserData> watchUser(String? userId) {
    return userDao!.watchUser(userId);
  }

  @override
  Future<void> deleteRefreshToken() async {
    return await storage!.delete(key: refreshKey);
  }

  @override
  Future<void> deleteToken() async {
    return await storage!.delete(key: tokenKey);
  }

  @override
  Future<void> deleteUserId() async {
    return await storage!.delete(key: userIdKey);
  }
}
