import 'package:nilesoft_erp/layers/data/models/add_customer.dart';

abstract class AddCustomerEvent {}

class OnAddCustomerInit extends AddCustomerEvent {}

class OnAddCustomer extends AddCustomerEvent {
  final AddCustomerModel customerModel;

  OnAddCustomer({required this.customerModel});
}
