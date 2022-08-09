import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/user/user_table.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:drift/drift.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UserTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(AppDatabase db) : super(db);

  Future<void> insertUser(User user) async {
    await into(userTable).insertOnConflictUpdate(UserTable.fromUser(user));
  }

  Future<void> deleteUser(User user) async {
    await delete(userTable).go();
  }

  Stream<UserData> watchUser(String? userId) {
    return (select(userTable)..where((tbl) => tbl.id.equals(userId)))
        .watchSingle();
  }
}
