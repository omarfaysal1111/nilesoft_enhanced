import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';

abstract class InvoiceRepo {
  Future<List<SalesModel>> getInvoices();
  Future<SalesModel> getInvoiceById({required int id});
  Future<void> createInvoice({required SalesModel invoice});
  Future<List<SalesModel>> previewallInvoices();
  Future<SalesModel> previewsingleInvoice({required SalesModel invoice});
  Future<void> editInvoice({required SalesModel invoice});
  Future<void> deleteInvoice({required int id});
}
