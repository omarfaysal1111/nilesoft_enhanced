import 'package:nilesoft_erp/layers/data/models/customers_model.dart';

class CashinState {}

class CashinInitial extends CashinState {}

class CashinLoadedState extends CashinState {
  final List<CustomersModel> customers;
  final CustomersModel? selectedCustomer;
  CashinLoadedState({required this.customers, this.selectedCustomer});
}

class CashInSavedSuccessfuly extends CashinState {}
