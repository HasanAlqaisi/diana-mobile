import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/auth/auth_local_source.dart';
import 'package:diana/data/data_sources/auth/auth_remote_source.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/user/user_dao.dart';
import 'package:diana/data/repos/auth_repo_impl.dart';
import 'package:diana/domain/repos/auth_repo.dart';
import 'package:diana/domain/usecases/auth/login_user_usecase.dart';
import 'package:diana/domain/usecases/auth/register_user_usecase.dart';
import 'package:diana/presentation/login/controller/login_controller.dart';
import 'package:diana/presentation/register/controller/registeration_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.asNewInstance();

Future<void> init() async {
  externalLibsInjection();

  controllersInjection();

  usecasesInjection();

  reposInjection();

  remoteSourceInjection();

  localSourceInjection();

  await databaseInjection();

  daoInjection();
}

void externalLibsInjection() {
  sl.registerLazySingleton<NetWorkInfo>(
      () => NetWorkInfoImpl(connectionChecker: sl()));

  sl.registerLazySingleton(() => DataConnectionChecker());

  sl.registerLazySingleton(() => http.Client());

  sl.registerLazySingleton(() => FlutterSecureStorage());
}

void controllersInjection() {
  sl.registerFactory(() => LoginController(sl()));
  sl.registerFactory(() => RegistrationController(sl()));
}

void usecasesInjection() {
  sl.registerLazySingleton(() => LoginUserUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUserUsecase(sl()));
}

void reposInjection() {
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      netWorkInfo: sl(),
      remoteSource: sl(),
      authLocalSource: sl(),
    ),
  );
}

void remoteSourceInjection() {
  sl.registerLazySingleton<AuthRemoteSource>(
      () => AuthRemoteSourceImpl(client: sl()));
}

void localSourceInjection() {
  sl.registerLazySingleton<AuthLocalSource>(
      () => AuthLocalSourceImpl(userDao: sl(), storage: sl()));
}

Future<void> databaseInjection() async {
  //Query exceutor
  sl.registerLazySingletonAsync<QueryExecutor>(() async {
    return LazyDatabase(() async {
      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'db.sqlite'));
      return VmDatabase(file);
    });
  });

  //App database
  await sl.isReady<QueryExecutor>();
  sl.registerLazySingleton(() => AppDatabase(sl()));
}

void daoInjection() {
  sl.registerLazySingleton(() => UserDao(sl()));
}
