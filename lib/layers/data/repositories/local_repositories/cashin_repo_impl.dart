import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/cashin_repo.dart';

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
    //
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
    CashinModel? cashinModel = await _databaseHelper.getRecordById<CashinModel>(
        tableName, id, CashinModel.fromMap);
    return cashinModel!;
  }

  @override
  Future<List<CashinModel>> getCashIns({required String tableName}) async {
    List<CashinModel> cashins = await _databaseHelper.getAllRecords(
        DatabaseConstants.cashinHeadTable, CashinModel.fromMap);
    return cashins;
  }

  @override
  Future<void> updateCashIn(
      {required CashinModel model, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.updateRecord(model, tableName, model.id!);
  }

  @override
  Future<void> createCashInDtl({required CashInDtl cashinDtl}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertRecord<CashInDtl>(
        cashinDtl, DatabaseConstants.cashInDtlTable);
  }
}
