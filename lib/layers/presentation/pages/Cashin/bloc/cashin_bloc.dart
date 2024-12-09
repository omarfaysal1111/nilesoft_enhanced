import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/cashin_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_state.dart';

class CashinBloc extends Bloc<CashinEvent, CashinState> {
  CashinBloc() : super(CashinInitial()) {
    on<FetchCashinClientsEvent>(_fetchClients);
    on<SaveCashinPressed>(onCashInSave);
  }

  Future<void> _fetchClients(
      FetchCashinClientsEvent event, Emitter<CashinState> emit) async {
    try {
      CustomersRepoImpl customersRepoImpl = CustomersRepoImpl();
      List<CustomersModel> customers = await customersRepoImpl.getCustomers(
          tableName: DatabaseConstants.customersTable);
      emit(CashinLoadedState(customers: customers));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> onCashInSave(
      SaveCashinPressed event, Emitter<CashinState> emit) async {
    CashinRepoImpl cashinRepoImpl = CashinRepoImpl();
    await cashinRepoImpl.createCashIn(
        invoice: event.cashinModel,
        tableName: DatabaseConstants.cashinHeadTable);
    emit(CashInSavedSuccessfuly());
  }
}
