import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/ledger_parameter_model.dart';

abstract class LedgerEvent {}

class OnFromDateChanged extends LedgerEvent {
  final String date;

  OnFromDateChanged({required this.date});
}

class OnCustomerSelected extends LedgerEvent {
  final CustomersModel selectedCustomer;
  final List<CustomersModel> customers;
  OnCustomerSelected({required this.selectedCustomer, required this.customers});
}

class OnToDateChanged extends LedgerEvent {
  final String date;

  OnToDateChanged({required this.date});
}

class OnLedgerIntial extends LedgerEvent {}

class OnLedgerLoaded extends LedgerEvent {
  OnLedgerLoaded();
}

class OnLedgerSubmit extends LedgerEvent {
  final LedgerParametersModel ledgerParameters;

  OnLedgerSubmit({required this.ledgerParameters});
}

class OnLedgerPageChanged extends LedgerEvent {
  final LedgerParametersModel ledgerParameters;

  OnLedgerPageChanged({required this.ledgerParameters});
}
