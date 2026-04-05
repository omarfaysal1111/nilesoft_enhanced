import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/discount_list_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/discount_list_local_repo.dart';

final DatabaseHelper _databaseHelper = DatabaseHelper();

class DiscountListRepoImpl implements DiscountListLocalRepo {
  @override
  Future<void> addAllDiscountList(
      {required List<DiscountListModel> items, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertListRecords(items, tableName);
  }

  @override
  Future<void> deleteAllDiscountList({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.deleteAllRecord(tableName);
  }

  /// [listId] = customer `dislistid` (stored in column `listid`).
  @override
  Future<DiscountListModel?> getDiscountListItem({
    required String listId,
    required double catId,
  }) async {
    DatabaseConstants.startDB(_databaseHelper);
    final String l = listId.trim();

    List<Map<String, dynamic>> maps = await _databaseHelper.db.rawQuery(
      '''
      SELECT * FROM ${DatabaseConstants.discountListTable}
      WHERE trim(cast(listid as text)) = trim(?)
        AND (discountcatid = ? OR abs(discountcatid - ?) < 1e-6)
      LIMIT 1
      ''',
      [l, catId, catId],
    );

    if (maps.isEmpty && catId == catId.roundToDouble()) {
      maps = await _databaseHelper.db.rawQuery(
        '''
        SELECT * FROM ${DatabaseConstants.discountListTable}
        WHERE trim(cast(listid as text)) = trim(?)
          AND discountcatid = ?
        LIMIT 1
        ''',
        [l, catId.toInt()],
      );
    }

    if (maps.isEmpty) return null;
    return DiscountListModel.fromMap(maps.first);
  }
}
