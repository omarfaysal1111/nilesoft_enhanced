import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';

abstract class RemoteCustomersRepo {
  Future<List<CustomersModel>> getAllCustomers();
}
