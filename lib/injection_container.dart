import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:diana/core/network/network_info.dart';
import 'package:diana/data/data_sources/auth/auth_local_source.dart';
import 'package:diana/data/data_sources/auth/auth_remote_source.dart';
import 'package:diana/data/data_sources/habit/habit_local_source.dart';
import 'package:diana/data/data_sources/habit/habit_remote_source.dart';
import 'package:diana/data/data_sources/subtask/subtask_remote_source.dart';
import 'package:diana/data/data_sources/tag/tag_remote_source.dart';
import 'package:diana/data/data_sources/task/task_local_source.dart';
import 'package:diana/data/data_sources/task/task_remote_source.dart';
import 'package:diana/data/data_sources/tasktag/tasktag_local_source.dart';
import 'package:diana/data/data_sources/tasktag/tasktag_remote_source.dart';
import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/habit_log/habitlog_dao.dart';
import 'package:diana/data/database/models/subtask/subtask_dao.dart';
import 'package:diana/data/database/models/tag/tag_dao.dart';
import 'package:diana/data/database/models/task/task_dao.dart';
import 'package:diana/data/database/models/tasktag/tasktag_dao.dart';
import 'package:diana/data/database/models/user/user_dao.dart';
import 'package:diana/data/repos/auth_repo_impl.dart';
import 'package:diana/data/repos/task_repo_impl.dart';
import 'package:diana/domain/repos/auth_repo.dart';
import 'package:diana/domain/repos/habit_repo.dart';
import 'package:diana/domain/repos/task_repo.dart';
import 'package:diana/domain/usecases/auth/login_user_usecase.dart';
import 'package:diana/domain/usecases/auth/register_user_usecase.dart';
import 'package:diana/domain/usecases/auth/request_token_usecase.dart';
import 'package:diana/domain/usecases/habit/edit_habit_usecase.dart';
import 'package:diana/domain/usecases/habit/get_habit_logs.dart';
import 'package:diana/domain/usecases/habit/get_habits_usecase.dart';
import 'package:diana/domain/usecases/habit/insert_habit_usecase.dart';
import 'package:diana/domain/usecases/habit/insert_habitlog_usecase.dart';
import 'package:diana/domain/usecases/habit/watch_all_habits_usecase.dart';
import 'package:diana/domain/usecases/habit/watch_today_habits_usecase.dart';
import 'package:diana/domain/usecases/home/get_refresh_token_usecase.dart';
import 'package:diana/domain/usecases/home/get_token_usecase.dart';
import 'package:diana/domain/usecases/home/get_userid_usecase.dart';
import 'package:diana/domain/usecases/task/delete_task_usecase.dart';
import 'package:diana/domain/usecases/task/edit_task_usecase.dart';
import 'package:diana/domain/usecases/task/get_subtasks_usecase.dart';
import 'package:diana/domain/usecases/task/get_tags_usecase.dart';
import 'package:diana/domain/usecases/task/get_tasks_usecase.dart';
import 'package:diana/domain/usecases/task/insert_tag_usecase.dart';
import 'package:diana/domain/usecases/task/insert_task_usecase.dart';
import 'package:diana/domain/usecases/task/watch_all_tags_usecase.dart';
import 'package:diana/domain/usecases/task/watch_all_tasks_usecase.dart';
import 'package:diana/domain/usecases/task/watch_completed_tasks_usecase.dart';
import 'package:diana/domain/usecases/task/watch_missed_tasks_usecase.dart';
import 'package:diana/domain/usecases/task/watch_tags_for_task.dart';
import 'package:diana/domain/usecases/task/watch_today_tasks_usecase.dart';
import 'package:diana/presentation/habit/controllers/habit_controller.dart';
import 'package:diana/presentation/home/home_controller.dart';
import 'package:diana/presentation/login/controller/login_controller.dart';
import 'package:diana/presentation/register/controller/registeration_controller.dart';
import 'package:diana/presentation/task/controller/add_task_controller.dart';
import 'package:diana/presentation/task/controller/task_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'data/data_sources/habitlog/habitlog_remote_source.dart';
import 'data/database/models/habit/habit_dao.dart';
import 'data/repos/habit_repo_impl.dart';

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
  sl.registerFactory(() => HomeController(sl(), sl(), sl()));

  sl.registerFactory(() => LoginController(sl()));
  sl.registerFactory(() => RegistrationController(sl()));
  sl.registerFactory(() => TaskController(sl(), sl(), sl(), sl(), sl(), sl(),
      sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => AddTaskController(sl(), sl(), sl(), sl()));
  sl.registerFactory(
      () => HabitController(sl(), sl(), sl(), sl(), sl(), sl(), sl()));
}

void usecasesInjection() {
  sl.registerLazySingleton(() => LoginUserUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUserUsecase(sl()));

  sl.registerLazySingleton(() => RequestTokenUsecase(sl()));
  sl.registerLazySingleton(() => GetTokenUseCase(authRepo: sl()));
  sl.registerLazySingleton(() => GetRefreshTokenUseCase(authRepo: sl()));
  sl.registerLazySingleton(() => GetUserIdUseCase(authRepo: sl()));

  sl.registerLazySingleton(() => GetTagsUseCase(taskRepo: sl()));
  sl.registerLazySingleton(() => GetTasksUseCase(taskRepo: sl()));
  sl.registerLazySingleton(() => InsertTaskUseCase(taskRepo: sl()));
  sl.registerLazySingleton(() => DeleteTaskUseCase(taskRepo: sl()));
  sl.registerLazySingleton(() => WatchTodayTasksUseCase(sl()));
  sl.registerLazySingleton(() => WatchAllTasksUseCase(sl()));
  sl.registerLazySingleton(() => WatchCompletedTasksUseCase(sl()));
  sl.registerLazySingleton(() => WatchMissedTasksUseCase(sl()));
  sl.registerLazySingleton(() => WatchAllTagsUseCase(sl()));
  sl.registerLazySingleton(() => WatchTagsForTaskUseCase(sl()));
  sl.registerLazySingleton(() => GetSubtasksUseCase(taskRepo: sl()));
  sl.registerLazySingleton(() => EditTaskUseCase(taskRepo: sl()));
  sl.registerLazySingleton(() => InsertTagUseCase(taskRepo: sl()));

  sl.registerLazySingleton(() => InsertHabitUseCase(habitRepo: sl()));
  sl.registerLazySingleton(() => InsertHabitLogUseCase(habitRepo: sl()));
  sl.registerLazySingleton(() => EditHabitUseCase(habitRepo: sl()));
  sl.registerLazySingleton(() => GetHabitsUseCase(habitRepo: sl()));
  sl.registerLazySingleton(() => GetHabitLogsUseCase(habitRepo: sl()));
  sl.registerLazySingleton(() => WatchAllHabitUseCase(sl()));
  sl.registerLazySingleton(() => WatchTodayHabitUseCase(sl()));
}

void reposInjection() {
  sl.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      netWorkInfo: sl(),
      remoteSource: sl(),
      authLocalSource: sl(),
    ),
  );

  sl.registerLazySingleton<TaskRepo>(
    () => TaskRepoImpl(
      netWorkInfo: sl(),
      taskRemoteSource: sl(),
      taskLocalSource: sl(),
      subtaskRemoteSource: sl(),
      tagRemoteSource: sl(),
      taskTagRemoteSource: sl(),
      taskTagLocalSoucre: sl(),
    ),
  );

  sl.registerLazySingleton<HabitRepo>(
    () => HabitRepoImpl(
      netWorkInfo: sl(),
      habitRemoteSource: sl(),
      habitLocalSource: sl(),
      habitlogRemoteSource: sl(),
    ),
  );
}

void remoteSourceInjection() {
  sl.registerLazySingleton<AuthRemoteSource>(
      () => AuthRemoteSourceImpl(client: sl()));

  sl.registerLazySingleton<TaskRemoteSource>(
      () => TaskRemoteSourceImpl(client: sl()));

  sl.registerLazySingleton<SubtaskRemoteSource>(
      () => SubtaskRemoteSourceImpl(client: sl()));

  sl.registerLazySingleton<TagRemoteSource>(
      () => TagRemoteSourceImpl(client: sl()));

  sl.registerLazySingleton<TaskTagRemoteSource>(
      () => TaskTagRemoteSourceImpl(client: sl()));

  sl.registerLazySingleton<HabitRemoteSource>(
      () => HabitRemoteSourceImpl(client: sl()));

  sl.registerLazySingleton<HabitlogRemoteSource>(
      () => HabitlogRemoteSourceImpl(client: sl()));
}

void localSourceInjection() {
  sl.registerLazySingleton<AuthLocalSource>(
      () => AuthLocalSourceImpl(userDao: sl(), storage: sl()));

  sl.registerLazySingleton<TaskLocalSource>(() => TaskLocalSourceImpl(
        taskDao: sl(),
        tagDao: sl(),
        subTaskDao: sl(),
      ));

  sl.registerLazySingleton<TaskTagLocalSoucre>(
      () => TaskTagLocalSoucreImpl(taskTagDao: sl()));

  sl.registerLazySingleton<HabitLocalSource>(
      () => HabitLocalSourceImpl(habitDao: sl(), habitlogDao: sl()));
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

  sl.registerLazySingleton(() => TaskDao(sl()));
  sl.registerLazySingleton(() => TagDao(sl()));
  sl.registerLazySingleton(() => SubTaskDao(sl()));
  sl.registerLazySingleton(() => TaskTagDao(sl()));

  sl.registerLazySingleton(() => HabitDao(sl()));
  sl.registerLazySingleton(() => HabitlogDao(sl()));
}
