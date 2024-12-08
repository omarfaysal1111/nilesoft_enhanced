import 'package:nilesoft_erp/layers/data/models/customers_model.dart';

abstract class RemoteCustomersRepo {
  Future<List<CustomersModel>> getAllCustomers();
}
