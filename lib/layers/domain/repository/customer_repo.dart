import 'package:nilesoft_erp/layers/data/models/customers_model.dart';

abstract class CustomerRepo {
  Future<List<CustomersModel>> getCustomers({required String tableName});
  Future<CustomersModel> getCustomerById(
      {required int id, required String tableName});
  Future<void> createCustomer(
      {required CustomersModel customer, required String tableName});

  Future<void> editCustomers(
      {required CustomersModel customer, required String tableName});
  Future<void> deleteCustomer({required int id});
}
