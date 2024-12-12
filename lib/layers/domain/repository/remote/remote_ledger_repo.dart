import 'package:nilesoft_erp/layers/data/models/ledger_first_res.dart';
import 'package:nilesoft_erp/layers/data/models/ledger_model.dart';
import 'package:nilesoft_erp/layers/data/models/ledger_parameter_model.dart';

abstract class RemoteLedgerRepo {
  Future<LedgerFirstRes> getLedger({required LedgerParametersModel param});
  Future<List<LedgerModel>> getPage(
      {required LedgerParametersModel param,
      int pagelen,
      List<LedgerModel> page});
}
