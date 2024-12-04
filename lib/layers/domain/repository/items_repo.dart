import 'package:nilesoft_erp/layers/data/models/items_model.dart';

abstract class ItemsRepo {
  Future<List<ItemsModel>> getItems({required String tableName});
  Future<ItemsModel> getItemById({required int id, required String tableName});
  Future<void> createItem(
      {required ItemsModel item, required String tableName});

  Future<void> editItems({required ItemsModel item, required String tableName});
  Future<void> deleteItem({required int id});
}
