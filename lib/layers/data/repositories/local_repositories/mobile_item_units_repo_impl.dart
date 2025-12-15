import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/domain/models/mobile_item_units_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/mobile_item_units_repo.dart';

final DatabaseHelper _databaseHelper = DatabaseHelper();

class MobileItemUnitsRepoImpl implements MobileItemUnitsRepo {
  @override
  Future<void> createMobileItemUnit(
      {required MobileItemUnitsModel item, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertRecord<MobileItemUnitsModel>(item, tableName);
  }

  @override
  Future<List<MobileItemUnitsModel>> getMobileItemUnits(
      {required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getAllRecords(
        tableName, MobileItemUnitsModel.fromMap);
  }

  @override
  Future<List<MobileItemUnitsModel>> getMobileItemUnitsByItemId(
      {required String itemId, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    final List<Map<String, dynamic>> result = await _databaseHelper.db.query(
        tableName, where: 'itemid = ?', whereArgs: [itemId]);
    return result.map((map) => MobileItemUnitsModel.fromMap(map)).toList();
  }

  @override
  Future<void> addAllMobileItemUnits(
      {required List<MobileItemUnitsModel> items,
      required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertListRecords(items, tableName);
  }

  @override
  Future<void> deleteAllMobileItemUnits({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.deleteAllRecord(tableName);
  }
}

