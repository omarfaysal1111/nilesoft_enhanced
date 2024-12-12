import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';

class CashinState {}

class CashinInitial extends CashinState {}

class CashinLoadedState extends CashinState {
  final List<CustomersModel> customers;
  final CustomersModel? selectedCustomer;
  final String? docNo;
  CashinLoadedState({
    required this.customers,
    this.selectedCustomer,
    this.docNo,
  });
}

class CashInUpdateSubmitted {}

class CashInUpdateSucc extends CashinState {}

class CashInToEditState extends CashinState {
  final CashinModel cashinModel;
  final List<CustomersModel> customers;
  CashInToEditState({required this.cashinModel, required this.customers});
}

class CashInSavedSuccessfuly extends CashinState {}
