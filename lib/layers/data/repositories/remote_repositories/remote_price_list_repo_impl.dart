import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/models/price_list_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_price_list_repo.dart';

class RemotePriceListRepoImpl implements RemotePriceListRepo {
  @override
  Future<List<PriceListModel>> getAllPriceList() async {
    return await MainFun.getReq(
        PriceListModel.fromMap, 'nsbase/getpricelist');
  }
}
