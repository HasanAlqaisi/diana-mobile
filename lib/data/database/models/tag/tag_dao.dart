import 'package:diana/data/database/app_database/app_database.dart';
import 'package:diana/data/database/models/tag/tag_table.dart';
import 'package:diana/data/remote_models/tag/tag_result.dart';
import 'package:diana/data/remote_models/tag/tag_response.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'tag_dao.g.dart';

@UseDao(tables: [TagTable])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(AppDatabase db) : super(db);

  Future<int> deleteTag(String tagId) {
    return (delete(tagTable)..where((tbl) => tbl.id.equals(tagId))).go();
  }

  Future<int> insertTag(TagResult tagResult) {
    return into(tagTable)
        .insertOnConflictUpdate(TagTable.fromTagResult(tagResult));
  }

  Future<void> deleteAndinsertTags(
    TagResponse tagResponse,
  ) async {
    return transaction(() async {
      await delete(tagTable).go();
      await batch((batch) {
        batch.insertAllOnConflictUpdate(
            tagTable, TagTable.fromTagResponse(tagResponse.results));
      });
    });
  }

  Future<void> insertTags(TagResponse tagResponse) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(
          tagTable, TagTable.fromTagResponse(tagResponse.results));
    });
  }
}
