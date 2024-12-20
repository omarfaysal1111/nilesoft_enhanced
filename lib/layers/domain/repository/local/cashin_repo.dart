import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';

abstract class CashinRepo {
  Future<List<CashinModel>> getCashIns({required String tableName});
  Future<CashinModel> getCashInById(
      {required int id, required String tableName});
  Future<void> createCashIn(
      {required CashinModel invoice, required String tableName});
  Future<void> editCashIn(
      {required CashinModel invoice, required String tableName});
  Future<void> deleteCashIn({required int id});
  Future<void> updateCashIn(
      {required CashinModel model, required String tableName});
}
