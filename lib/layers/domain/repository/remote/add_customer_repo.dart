import 'package:nilesoft_erp/layers/domain/models/add_customer.dart';

abstract class AddCustomerRepo {
  Future<void> addCustomer({required AddCustomerModel customer});
}
