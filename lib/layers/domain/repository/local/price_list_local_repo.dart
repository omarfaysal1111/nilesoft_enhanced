import 'package:nilesoft_erp/layers/domain/models/price_list_model.dart';

abstract class PriceListLocalRepo {
  Future<void> addAllPriceList(
      {required List<PriceListModel> items, required String tableName});

  Future<void> deleteAllPriceList({required String tableName});

  Future<PriceListModel?> getPriceListItem({
    required String listId,
    required String itemId,
  });
}
