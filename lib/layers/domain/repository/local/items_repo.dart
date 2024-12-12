import 'package:nilesoft_erp/layers/domain/models/items_model.dart';

abstract class ItemsRepo {
  Future<List<ItemsModel>> getItems({required String tableName});
  Future<ItemsModel> getItemById({required int id, required String tableName});
  Future<void> createItem(
      {required ItemsModel item, required String tableName});
  Future<void> addAllItems(
      {required List<ItemsModel> items, required String tableName});
  Future<void> editItems({required ItemsModel item, required String tableName});
  Future<void> deleteItem({required int id});
  Future<void> deleteAllItems({required String tableName});
}
