import 'package:nilesoft_erp/layers/data/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_items_repo.dart';

class RemoteItemRepoImpl implements RemoteItemsRepo {
  @override
  Future<List<ItemsModel>> getAllItems() async {
    return await MainFun.getReq(ItemsModel.fromMap, "nsbase/getinvenitembal");
  }
}
