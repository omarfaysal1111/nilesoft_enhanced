import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/models/baisc_response.dart';
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_cashin_repo.dart';

class RemoteCashinRepoImpl extends RemoteCashineRepo {
  List<CashInDtl> cashDtls = [];
  @override
  Future<void> sendInvoices(
      {required String headTableName, required String endPoint}) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    DatabaseConstants.startDB(databaseHelper);

    List<CashinModel> cashinModel =
        await databaseHelper.getAllRecords(headTableName, CashinModel.fromMap);

    for (var i = 0; i < cashinModel.length; i++) {
      CashInDtl? cashInDtl = await databaseHelper.getRecordById(
          DatabaseConstants.cashInDtlTable,
          cashinModel[i].id!,
          CashInDtl.fromMap);
      //cashinModel[i].mobileuuid = "7f5b672f1be969cb";
      cashinModel[i].id = 0;
      cashinModel[i].net1 = cashinModel[i].total;
      cashInDtl!.amount = cashinModel[i].total;
      cashInDtl.descr = cashinModel[i].descr;
      cashInDtl.docno = cashinModel[i].docNo;

      cashInDtl.discount = 0;
      cashInDtl.branchid = 0;
      cashInDtl.shiftid = 0;
      cashInDtl.serial = 0;
      cashInDtl.docno = '';
      cashInDtl.id = "0";
      cashInDtl.salesmanid = '';
      cashDtls.add(cashInDtl);
      CashinModelSend cashinModelSend =
          CashinModelSend(cashInDtl: cashDtls, cashinModelHead: cashinModel[i]);
      if (kDebugMode) {
        print(jsonEncode(cashinModelSend));
      }
      await MainFun.postReq(
          ResponseModel.fromJson, "cashin/addnew", cashinModelSend.toJson());
      databaseHelper.db.rawUpdate(
          "UPDATE $headTableName SET sent = 1 where id='${cashinModel[i].id}'");
    }
  }
}
