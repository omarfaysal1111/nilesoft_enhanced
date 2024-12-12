import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/ledger_first_res.dart';
import 'package:nilesoft_erp/layers/data/models/ledger_model.dart';
import 'package:nilesoft_erp/layers/data/remote/remote_repositories/remote_ledger_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/ledger/bloc/ledger_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/ledger/bloc/ledger_state.dart';

class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  LedgerBloc() : super(LedgerInitial()) {
    on<OnLedgerIntial>(_onLedgerInitial);
    on<OnLedgerSubmit>(_onLedgerSubmitted);
    on<OnLedgerPageChanged>(_onLedgerPage);
    on<OnFromDateChanged>(_onFromDateChanged);
    on<OnToDateChanged>(_onToDateChanged);
    on<OnCustomerSelected>(_onCustomerSelected);
  }
  Future<void> _onLedgerInitial(
      OnLedgerIntial event, Emitter<LedgerState> emit) async {
    CustomersRepoImpl customersRepoImpl = CustomersRepoImpl();
    List<CustomersModel> customers = await customersRepoImpl.getCustomers(
        tableName: DatabaseConstants.customersTable);
    emit(LedgerLoaded(customers: customers));
  }

  Future<void> _onLedgerSubmitted(
      OnLedgerSubmit event, Emitter<LedgerState> emit) async {
    RemoteLedgerRepoImpl ledgerRepoImpl = RemoteLedgerRepoImpl();
    LedgerFirstRes ledgerFirst =
        await ledgerRepoImpl.getLedger(param: event.ledgerParameters);
    emit(LedgerSubmitted(ledgerFirstRes: ledgerFirst));
  }

  void _onCustomerSelected(
      OnCustomerSelected event, Emitter<LedgerState> emit) {
    emit(LedgerLoaded(
        customers: event.customers, selectedCustomer: event.selectedCustomer));
  }

  Future<void> _onLedgerPage(
      OnLedgerPageChanged event, Emitter<LedgerState> emit) async {
    RemoteLedgerRepoImpl ledgerRepoImpl = RemoteLedgerRepoImpl();
    List<LedgerModel> page =
        await ledgerRepoImpl.getPage(param: event.ledgerParameters);
    emit(LedgerPageChanged(ledger: page));
  }

  void _onFromDateChanged(OnFromDateChanged event, Emitter<LedgerState> emit) {
    emit(FromDateChanged(date: event.date));
  }

  void _onToDateChanged(OnToDateChanged event, Emitter<LedgerState> emit) {
    emit(ToDateChanged(date: event.date));
  }
}
