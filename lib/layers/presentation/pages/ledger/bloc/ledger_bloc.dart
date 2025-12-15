import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_first_res.dart';
import 'package:nilesoft_erp/layers/domain/models/ledger_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/remote_ledger_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/customers_repo_impl.dart';
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

  // ignore: unused_element
  Future<void> _onCutomersSelected(
      CustomerSelectedEvent event, Emitter<LedgerState> emit) async {}
  Future<void> _onLedgerSubmitted(
      OnLedgerSubmit event, Emitter<LedgerState> emit) async {
    try {
      RemoteLedgerRepoImpl ledgerRepoImpl = RemoteLedgerRepoImpl();
      LedgerFirstRes ledgerFirst =
          await ledgerRepoImpl.getLedger(param: event.ledgerParameters);
      emit(LedgerSubmitted(ledgerFirstRes: ledgerFirst));
    } catch (e) {
      String errorMsg = "حدث خطأ أثناء جلب البيانات";
      if (e.toString().contains("401")) {
        errorMsg = "انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى";
      } else if (e.toString().contains("Error posting data") || e.toString().contains("Error fetching data")) {
        errorMsg = "فشل الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت";
      } else {
        errorMsg = e.toString().replaceAll("Exception: ", "");
      }
      emit(LedgerError(errorMessage: errorMsg));
    }
  }

  void _onCustomerSelected(
      OnCustomerSelected event, Emitter<LedgerState> emit) {
    emit(LedgerLoaded(
        customers: event.customers, selectedCustomer: event.selectedCustomer));
  }

  Future<void> _onLedgerPage(
      OnLedgerPageChanged event, Emitter<LedgerState> emit) async {
    try {
      RemoteLedgerRepoImpl ledgerRepoImpl = RemoteLedgerRepoImpl();
      List<LedgerModel> page =
          await ledgerRepoImpl.getPage(param: event.ledgerParameters);
      emit(LedgerPageChanged(ledger: page));
    } catch (e) {
      String errorMsg = "حدث خطأ أثناء جلب البيانات";
      if (e.toString().contains("401")) {
        errorMsg = "انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى";
      } else if (e.toString().contains("Error posting data") || e.toString().contains("Error fetching data")) {
        errorMsg = "فشل الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت";
      } else {
        errorMsg = e.toString().replaceAll("Exception: ", "");
      }
      emit(LedgerError(errorMessage: errorMsg));
    }
  }

  void _onFromDateChanged(OnFromDateChanged event, Emitter<LedgerState> emit) {
    emit(FromDateChanged(date: event.date));
  }

  void _onToDateChanged(OnToDateChanged event, Emitter<LedgerState> emit) {
    emit(ToDateChanged(date: event.date));
  }
}
