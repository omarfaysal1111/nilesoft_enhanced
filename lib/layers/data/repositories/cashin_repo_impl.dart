import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/cashin_repo.dart';

DatabaseHelper _databaseHelper = DatabaseHelper();

class CashinRepoImpl implements CashinRepo {
  @override
  Future<void> createCashIn(
      {required CashinModel invoice, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertRecord<CashinModel>(invoice, tableName);
  }

  @override
  Future<void> deleteCashIn({required int id}) {
    // TODO: implement deleteCashIn
    throw UnimplementedError();
  }

  @override
  Future<void> editCashIn(
      {required CashinModel invoice, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.updateRecord(invoice, tableName, invoice.id!);
  }

  @override
  Future<CashinModel> getCashInById(
      {required int id, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    CashinModel? salesmodel = await _databaseHelper.getRecordById<CashinModel>(
        tableName, id, CashinModel.fromMap);
    return salesmodel!;
  }

  @override
  Future<List<CashinModel>> getCashIns({required String tableName}) {
    // TODO: implement getCashIns
    throw UnimplementedError();
  }
}
