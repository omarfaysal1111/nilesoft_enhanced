import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/invoice_repo.dart';

class InvoiceRepoImpl implements InvoiceRepo {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> createInvoice({required SalesModel invoice}) async {
    _databaseHelper.initDB().whenComplete(
      () {
        print("Started");
      },
    );
    await _databaseHelper.insertInvoiceHead(invoice.salesHeadModel!);
  }

  @override
  Future<void> deleteInvoice({required int id}) async {}

  @override
  Future<void> editInvoice({required SalesModel invoice}) async {}

  @override
  Future<SalesModel> getInvoiceById({required int id}) {
    // TODO: implement getInvoiceById
    throw UnimplementedError();
  }

  @override
  Future<List<SalesModel>> getInvoices() {
    // TODO: implement getInvoices
    throw UnimplementedError();
  }

  @override
  Future<List<SalesModel>> previewallInvoices() {
    // TODO: implement previewallInvoices
    throw UnimplementedError();
  }

  @override
  Future<SalesModel> previewsingleInvoice({required SalesModel invoice}) {
    // TODO: implement previewsingleInvoice
    throw UnimplementedError();
  }
}
