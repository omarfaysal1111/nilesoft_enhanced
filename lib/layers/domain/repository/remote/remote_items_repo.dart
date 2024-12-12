import 'package:nilesoft_erp/layers/domain/models/items_model.dart';

abstract class RemoteItemsRepo {
  Future<List<ItemsModel>> getAllItems();
}
