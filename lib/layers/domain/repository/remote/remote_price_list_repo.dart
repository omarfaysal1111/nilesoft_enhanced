import 'package:nilesoft_erp/layers/domain/models/price_list_model.dart';

abstract class RemotePriceListRepo {
  Future<List<PriceListModel>> getAllPriceList();
}
