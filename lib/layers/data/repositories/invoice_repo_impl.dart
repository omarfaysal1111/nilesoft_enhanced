import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/invoice_repo.dart';

class InvoiceRepoImpl implements InvoiceRepo {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<void> createInvoice(
      {required SalesModel invoice, required String tableName}) async {
    _databaseHelper.initDB().whenComplete(
      () {
        print("Started");
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
    // TODO: implement previewallInvoices
    throw UnimplementedError();
  }

  @override
  Future<SalesModel> previewsingleInvoice({required SalesModel invoice}) {
    // TODO: implement previewsingleInvoice
    throw UnimplementedError();
  }
}
