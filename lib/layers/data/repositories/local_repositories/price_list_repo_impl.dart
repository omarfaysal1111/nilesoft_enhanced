import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/price_list_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/price_list_local_repo.dart';

final DatabaseHelper _databaseHelper = DatabaseHelper();

class PriceListRepoImpl implements PriceListLocalRepo {
  static const String _tbl = DatabaseConstants.priceListTable;

  @override
  Future<void> addAllPriceList(
      {required List<PriceListModel> items, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertListRecords(items, tableName);
  }

  @override
  Future<void> deleteAllPriceList({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.deleteAllRecord(tableName);
  }

  /// [listId] = customer `pricelistid` (same value stored in column `listid`).
  @override
  Future<PriceListModel?> getPriceListItem({
    required String listId,
    required String itemId,
  }) async {
    DatabaseConstants.startDB(_databaseHelper);
    final String iid = itemId.trim();
    final String l = listId.trim();
    final int? itemNum = int.tryParse(iid);
    final List<String> itemVariants = <String>[iid];
    if (itemNum != null) {
      final String c = itemNum.toString();
      if (c != iid) itemVariants.add(c);
    }

    List<Map<String, dynamic>> maps = [];

    for (final String iv in itemVariants) {
      maps = await _databaseHelper.db.rawQuery(
        '''
        SELECT * FROM $_tbl
        WHERE trim(cast(listid as text)) = trim(?)
          AND trim(cast(itemid as text)) = trim(?)
        LIMIT 1
        ''',
        [l, iv],
      );
      if (maps.isNotEmpty) break;
    }

    if (maps.isEmpty) return null;
    return PriceListModel.fromMap(maps.first);
  }
}
