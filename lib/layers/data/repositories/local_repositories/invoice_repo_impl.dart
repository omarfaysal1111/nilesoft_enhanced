import 'package:flutter/foundation.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/invoice_repo.dart';

class InvoiceRepoImpl implements InvoiceRepo {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> createInvoice(
      {required SalesModel invoice, required String tableName}) async {
    _databaseHelper.initDB().whenComplete(
      () {
        if (kDebugMode) {
          print("Started");
        }
      },
    );
    await _databaseHelper.insertRecord<SalesHeadModel>(
        invoice.salesHeadModel!, tableName);
    await _databaseHelper.insertListRecords<SalesDtlModel>(
        invoice.salesdtlModel, DatabaseConstants.salesInvoiceDtlTable);
  }

  @override
  Future<void> deleteInvoice({required int id}) async {}

  @override
  Future<void> editInvoice(
      {required SalesModel invoice, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.updateRecord(
        invoice, tableName, invoice.salesHeadModel!.id!);
  }

  @override
  Future<SalesModel> getInvoiceById(
      {required int id, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    SalesModel? salesmodel = await _databaseHelper.getRecordById<SalesModel>(
        tableName, id, SalesModel.fromMap);
    return salesmodel!;
  }

  @override
  Future<List<SalesModel>> getInvoices({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getAllRecords(tableName, SalesModel.fromMap);
  }

  @override
  Future<List<SalesModel>> previewallInvoices() {
    //
    throw UnimplementedError();
  }

  @override
  Future<SalesModel> previewsingleInvoice({required SalesModel invoice}) {
    //
    throw UnimplementedError();
  }

  @override
  Future<void> addInvoiceDtl(
      {required List<SalesDtlModel> invoiceDtl,
      required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertListRecords<SalesDtlModel>(
        invoiceDtl, tableName);
  }

  @override
  Future<void> addInvoiceHead(
      {required SalesHeadModel invoiceHead, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertRecord<SalesHeadModel>(invoiceHead, tableName);
  }

  @override
  Future<List<SalesHeadModel>> getInvoicesHead(
      {required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getAllRecords(
        tableName, SalesHeadModel.fromMap);
  }

  @override
  Future<List<SalesDtlModel>> getInvoicesDtl(
      {required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getAllRecords(
        tableName, SalesDtlModel.fromMap);
  }

  @override
  Future<List<SalesDtlModel>?> getSingleInvoiceDtl(
      {required String tableName, required String id}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getRecordsById(
        tableName, id, SalesDtlModel.fromMap);
  }

  @override
  Future<SalesHeadModel?> getSingleInvoiceHead(
      {required String tableName, required int id}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getRecordById(
        tableName, id, SalesHeadModel.fromMap);
  }

  @override
  Future<int?> getLatestId({required String tableNAme}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getLatestId(tableNAme);
  }

  @override
  Future<void> updateSalesDtl(
      {required List<SalesDtlModel> dtl, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    for (var i = 0; i < dtl.length; i++) {
      await _databaseHelper.updateRecordStringId(
          dtl[i], tableName, dtl[i].id.toString());
    }
  }

  @override
  Future<void> updateSalesHead(
      {required SalesHeadModel head, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.updateRecord(head, tableName, head.id!);
  }

  @override
  Future<List<SalesHeadModel>> getSentInvoices(
      {required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getRecordWhereSent(
        tableName, 1, SalesHeadModel.fromMap);
  }

  @override
  Future<List<SalesHeadModel>> getUnsentInvoices(
      {required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getRecordWhereSent(
        tableName, 0, SalesHeadModel.fromMap);
  }
}
