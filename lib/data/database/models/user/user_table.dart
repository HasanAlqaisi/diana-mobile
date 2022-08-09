import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/remote_models/auth/user.dart';
import 'package:drift/drift.dart';

@DataClassName('UserData')
class UserTable extends Table {
  TextColumn get id => text()();
  TextColumn get firstName => text().nullable()();
  TextColumn get lastName => text().nullable()();
  TextColumn get username => text()();
  TextColumn get email => text()();
  TextColumn get birthdate => text().nullable()();
  TextColumn get picture => text().nullable()();
  TextColumn get timeZone => text().nullable()();
  RealColumn get dailyTaskProgress => real().nullable()();

  @override
  String get tableName => 'user_table';

  @override
  Set<Column> get primaryKey => {id};

  static UserTableCompanion fromUser(User user) {
    return UserTableCompanion(
      id: Value(user.userId!),
      firstName: Value(user.firstName),
      lastName: Value(user.lastName),
      username: Value(user.username!),
      email: Value(user.email!),
      picture: Value(user.picture),
      birthdate: Value(user.birthdate),
      timeZone: Value(user.timeZone),
      dailyTaskProgress: Value(user.dailyProgress),
    );
  }
}
