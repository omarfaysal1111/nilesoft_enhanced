import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/items_repo.dart';

final DatabaseHelper _databaseHelper = DatabaseHelper();

class ItemsRepoImpl implements ItemsRepo {
  @override
  Future<void> createItem(
      {required ItemsModel item, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertRecord<ItemsModel>(item, tableName);
  }

  @override
  Future<void> deleteItem({required int id}) {
    DatabaseConstants.startDB(_databaseHelper);
    return _databaseHelper.deleteRecord("", id);
  }

  @override
  Future<void> editItems(
      {required ItemsModel item, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.updateRecord(
        item, tableName, int.parse(item.itemid!));
  }

  @override
  Future<ItemsModel> getItemById(
      {required int id, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    ItemsModel? items =
        await _databaseHelper.getRecordById(tableName, id, ItemsModel.fromMap);
    return items!;
  }

  @override
  Future<List<ItemsModel>> getItems({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getAllRecords(tableName, ItemsModel.fromMap);
  }

  @override
  Future<void> addAllItems(
      {required List<ItemsModel> items, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertListRecords(items, tableName);
  }

  @override
  Future<void> deleteAllItems({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.deleteAllRecord(tableName);
  }
}
