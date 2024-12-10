import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';

abstract class InvoiceRepo {
  Future<List<SalesModel>> getInvoices({required String tableName});
  Future<SalesModel> getInvoiceById(
      {required int id, required String tableName});
  Future<void> createInvoice(
      {required SalesModel invoice, required String tableName});
  Future<List<SalesModel>> previewallInvoices();
  Future<SalesModel> previewsingleInvoice({required SalesModel invoice});
  Future<void> editInvoice(
      {required SalesModel invoice, required String tableName});
  Future<void> deleteInvoice({required int id});
  Future<void> addInvoiceHead(
      {required SalesHeadModel invoiceHead, required String tableName});
  Future<void> addInvoiceDtl(
      {required List<SalesDtlModel> invoiceDtl, required String tableName});
  Future<List<SalesHeadModel>> getInvoicesHead({required String tableName});
  Future<List<SalesDtlModel>> getInvoicesDtl({required String tableName});
}
