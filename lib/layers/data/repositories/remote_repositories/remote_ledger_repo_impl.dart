import 'package:nilesoft_erp/layers/domain/models/ledger_first_res.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_model.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_parameter_model.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_ledger_repo.dart';

class RemoteLedgerRepoImpl extends RemoteLedgerRepo {
  @override
  Future<LedgerFirstRes> getLedger(
      {required LedgerParametersModel param}) async {
    LedgerFirstRes ledgerFirst = await MainFun.postReq(
        LedgerFirstRes.fromMap, "ledger/getNoofRows", param.toMap());
    return ledgerFirst;
  }

  @override
  Future<List<LedgerModel>> getPage(
      {required LedgerParametersModel param,
      int? pagelen,
      List<LedgerModel>? page}) async {
    List<LedgerModel> newPage = await MainFun.postReqFList(
        LedgerModel.fromMap, "ledger/getpage", param.toMap());

    return newPage;
  }
}
