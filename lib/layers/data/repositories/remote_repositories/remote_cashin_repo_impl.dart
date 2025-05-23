import 'package:flutter/foundation.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/cashin_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/models/baisc_response.dart';
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_cashin_repo.dart';

class RemoteCashinRepoImpl extends RemoteCashineRepo {
  @override
  Future<void> sendInvoices({
    required String headTableName,
    required String endPoint,
  }) async {
    final databaseHelper = DatabaseHelper();
    await DatabaseConstants.startDB(databaseHelper);

    final cashinRepoImpl = CashinRepoImpl();
    final List<CashinModel> unsentCashins =
        await cashinRepoImpl.getUnsentInvoices(
      tableName: DatabaseConstants.cashinHeadTable,
    );

    for (final cashin in unsentCashins) {
      final originalId = cashin.id!;
      final detail = await databaseHelper.getRecordById(
        DatabaseConstants.cashInDtlTable,
        originalId,
        CashInDtl.fromMap,
      );

      if (detail == null) {
        if (kDebugMode) print('Missing detail for cashin ID: $originalId');
        continue;
      }

      // Prepare models for sending
      cashin.id = 0; // Reset for API
      cashin.net1 = cashin.total;

      detail.amount = cashin.total;
      detail.descr = cashin.descr;
      detail.docno = cashin.docNo; // Make sure docno is preserved
      detail.discount = 0;
      detail.branchid = 0;
      detail.shiftid = 0;
      detail.serial = 0;
      detail.id = "0"; // Reset for API
      detail.salesmanid = '';

      final payload = CashinModelSend(
        cashInDtl: [detail],
        cashinModelHead: cashin,
      );

      if (kDebugMode) {
        print("Sending cashin: ${payload.toJson()}");
      }

      try {
        await MainFun.postReq(
          ResponseModel.fromJson,
          endPoint,
          payload.toJson(),
        );

        // Update local DB to mark as sent
        await databaseHelper.db.rawUpdate(
          "UPDATE $headTableName SET sent = 1 WHERE id = ?",
          [originalId],
        );
      } catch (e) {
        if (kDebugMode) print("Error sending cashin $originalId: $e");
      }
    }
  }
}
