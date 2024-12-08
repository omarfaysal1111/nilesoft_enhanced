import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/customer_repo.dart';

final DatabaseHelper _databaseHelper = DatabaseHelper();

class CustomersRepoImpl implements CustomerRepo {
  @override
  Future<void> createCustomer(
      {required CustomersModel customer, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertRecord<CustomersModel>(customer, tableName);
  }

  @override
  Future<void> deleteCustomer({required int id}) {
    //
    throw UnimplementedError();
  }

  @override
  Future<void> editCustomers(
      {required CustomersModel customer, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.updateRecord(
        customer, tableName, int.parse(customer.id!));
  }

  @override
  Future<CustomersModel> getCustomerById(
      {required int id, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    CustomersModel? salesmodel = await _databaseHelper
        .getRecordById<CustomersModel>(tableName, id, CustomersModel.fromMap);
    return salesmodel!;
  }

  @override
  Future<List<CustomersModel>> getCustomers({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getAllRecords(
        tableName, CustomersModel.fromMap);
  }

  @override
  Future<void> addAllCustomers(
      {required List<CustomersModel> customers,
      required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertListRecords(customers, tableName);
  }

  @override
  Future<void> deleteAllCustomers({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.deleteAllRecord(tableName);
  }
}
