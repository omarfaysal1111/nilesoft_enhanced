import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_first_res.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_model.dart';

class LedgerState {}

class LedgerInitial extends LedgerState {}

class LedgerLoading extends LedgerState {}

class FromDateChanged extends LedgerState {
  final String date;

  FromDateChanged({required this.date});
}

class ToDateChanged extends LedgerState {
  final String date;

  ToDateChanged({required this.date});
}

class LedgerLoaded extends LedgerState {
  final List<CustomersModel> customers;
  final CustomersModel? selectedCustomer;
  LedgerLoaded({required this.customers, this.selectedCustomer});
}

class LedgerSubmitted extends LedgerState {
  final LedgerFirstRes ledgerFirstRes;

  LedgerSubmitted({required this.ledgerFirstRes});
}

class LedgerPageChanged extends LedgerState {
  final List<LedgerModel> ledger;

  LedgerPageChanged({required this.ledger});
}
