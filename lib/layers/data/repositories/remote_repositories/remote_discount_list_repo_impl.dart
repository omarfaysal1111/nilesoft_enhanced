import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/models/discount_list_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_discount_list_repo.dart';

class RemoteDiscountListRepoImpl implements RemoteDiscountListRepo {
  @override
  Future<List<DiscountListModel>> getAllDiscountList() async {
    return await MainFun.getReq(
        DiscountListModel.fromMap, 'nsbase/getdiscountlist');
  }
}
