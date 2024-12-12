import 'package:flutter/foundation.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/settings_model.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/settings_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_invoice_repo.dart';

class RemoteInvoiceRepoImpl implements RemoteInvoiceRepo {
  @override
  Future<void> sendInvoices(
      {required String headTableName,
      required String dtlTableName,
      required String endPoint}) async {
    SettingsRepoImpl settingsRepoImpl = SettingsRepoImpl();
    List<SettingsModel> settingsModel = await settingsRepoImpl.getSettings(
        tableName: DatabaseConstants.settingsTable);
    DatabaseHelper databaseHelper = DatabaseHelper();
    DatabaseConstants.startDB(databaseHelper);
    String s1 = "select * from $headTableName where sent = 0";
    final List<Map<String, Object?>> invoicesHead =
        await databaseHelper.db.rawQuery(s1);
    for (var i = 0; i < invoicesHead.length; i++) {
      List<SalesModel> invoices = [];
      List<SalesDtlModel> salesDtlModel = await databaseHelper.getRecordsById(
          dtlTableName,
          invoicesHead[i]["id"].toString(),
          SalesDtlModel.fromMap);

      SalesHeadModel? salesHeadModel = await databaseHelper.getRecordById(
          headTableName,
          int.parse(invoicesHead[i]["id"].toString()),
          SalesHeadModel.fromMap);
      salesHeadModel!.invType = "0";

      salesHeadModel.accid = settingsModel[0].cashaccId;
      salesHeadModel.cashaccid = settingsModel[0].cashaccId;
      salesHeadModel.invenid = settingsModel[0].invId;
      salesHeadModel.visaid = settingsModel[0].visaId;
      invoices.add(SalesModel(
          salesHeadModel: salesHeadModel, salesdtlModel: salesDtlModel));

      await MainFun.postReq(SalesModel.fromMap, endPoint, invoices[i].toMap());
      if (kDebugMode) {
        print(invoices[i].toMap());
      }
      databaseHelper.db.rawUpdate(
          "UPDATE $headTableName SET sent = 1 where id='${invoices[i].salesHeadModel!.id}'");
    }
  }
}
