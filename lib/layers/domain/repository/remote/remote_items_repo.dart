import 'package:nilesoft_erp/layers/data/models/items_model.dart';

abstract class RemoteItemsRepo {
  Future<List<ItemsModel>> getAllItems();
}
