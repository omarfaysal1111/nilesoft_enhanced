import 'package:nilesoft_erp/layers/domain/models/mobile_item_units_model.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_mobile_item_units_repo.dart';

class RemoteMobileItemUnitsRepoImpl implements RemoteMobileItemUnitsRepo {
  @override
  Future<List<MobileItemUnitsModel>> getAllMobileItemUnits() async {
    return await MainFun.getReq(MobileItemUnitsModel.fromMap, "nsbase/getmobileitemunitsdata");
  }
}


