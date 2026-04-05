import 'package:nilesoft_erp/layers/domain/models/discount_list_model.dart';

abstract class DiscountListLocalRepo {
  Future<void> addAllDiscountList(
      {required List<DiscountListModel> items, required String tableName});

  Future<void> deleteAllDiscountList({required String tableName});

  Future<DiscountListModel?> getDiscountListItem({
    required String listId,
    required double catId,
  });
}
