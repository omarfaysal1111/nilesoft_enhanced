import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/models/serials_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_serials_repo.dart';

class RemoteSerialsRepoImpl implements RemoteSerialsRepo {
  @override
  Future<void> sendSerials(List<SerialsModel> serials) async {
    await MainFun.postReqList(SerialsModel.fromMap, "path", serials);
  }
}
