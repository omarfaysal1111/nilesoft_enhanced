import 'package:nilesoft_erp/layers/domain/models/discount_list_model.dart';

abstract class RemoteDiscountListRepo {
  Future<List<DiscountListModel>> getAllDiscountList();
}
