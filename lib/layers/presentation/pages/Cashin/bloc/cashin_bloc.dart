import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/cashin_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Cashin/bloc/cashin_state.dart';

class CashinBloc extends Bloc<CashinEvent, CashinState> {
  CashinBloc() : super(CashinInitial()) {
    on<FetchCashinClientsEvent>(_fetchClients);
    on<SaveCashinPressed>(onCashInSave);
    on<OnCashinToEdit>(cashinToEdit);
    on<OnCashinUpdate>(_onCashInUpdate);
    on<CustomerSelectedCashEvent>(_onCutomersSelected);
  }
  Future<void> _onCutomersSelected(
      CustomerSelectedCashEvent event, Emitter<CashinState> emit) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseConstants.startDB(dbHelper);

    final currentState = state;
    if (currentState is CashinLoadedState) {
      String s2 =
          "SELECT MAX(id) as latestId FROM ${DatabaseConstants.salesInvoiceHeadTable}";
      List<Map<String, Object?>> queryResult2 = await dbHelper.db.rawQuery(s2);
      if (queryResult2[0]["latestId"].toString() == "null" ||
          queryResult2[0]["latestId"].toString() == "" ||
          // ignore: unnecessary_null_comparison
          queryResult2[0]["latestId"].toString() == null) {
      } else {
        //id += int.parse(queryResult2[0]["latestId"].toString().trim());
      }
      emit(CashinLoadedState(
          customers: currentState.customers,
          selectedCustomer: event.selectedCustomer,
          docNo: await generateDocNumber()));
    }
  }

  String myDocNo = "";
  Future<void> _fetchClients(
      FetchCashinClientsEvent event, Emitter<CashinState> emit) async {
    try {
      CustomersRepoImpl customersRepoImpl = CustomersRepoImpl();
      List<CustomersModel> customers = await customersRepoImpl.getCustomers(
          tableName: DatabaseConstants.customersTable);
      emit(CashinLoadedState(
          customers: customers, docNo: await generateDocNumber()));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _onCashInUpdate(
      OnCashinUpdate event, Emitter<CashinState> emit) async {
    CashinRepoImpl cashinRepoImpl = CashinRepoImpl();
    await cashinRepoImpl.updateCashIn(
        model: event.cashinModel, tableName: DatabaseConstants.cashinHeadTable);
    emit(CashInUpdateSucc());
  }

  Future<void> cashinToEdit(
      OnCashinToEdit event, Emitter<CashinState> emit) async {
    CashinRepoImpl cashinRepoImpl = CashinRepoImpl();
    CashinModel cashinModel = await cashinRepoImpl.getCashInById(
        id: event.id, tableName: DatabaseConstants.cashinHeadTable);

    CustomersRepoImpl customersRepoImpl = CustomersRepoImpl();
    List<CustomersModel> customers = await customersRepoImpl.getCustomers(
        tableName: DatabaseConstants.customersTable);

    emit(CashInToEditState(cashinModel: cashinModel, customers: customers));
  }

  Future<String> generateDocNumber() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseConstants.startDB(dbHelper);
    String docNumber = "Mob";
    int nextId = 0;
    String strId = "";
    String s1 = "select mobileUserId as m from settings";
    List<Map<String, Object?>> queryResult1 = await dbHelper.db.rawQuery(s1);
    docNumber = "MOB${queryResult1[0]["m"]}";
    String s2 =
        "SELECT MAX(id) as latestId FROM ${DatabaseConstants.salesInvoiceHeadTable}";
    List<Map<String, Object?>> queryResult2 = await dbHelper.db.rawQuery(s2);

    if (queryResult2[0]["latestId"].toString() != "null") {
      nextId = int.parse(queryResult2[0]["latestId"].toString());
    }

    nextId = nextId + 1;
    strId = nextId.toString().trim();
    int c = 5 - strId.length;
    for (var i = 0; i < c; i++) {
      strId = "0$strId";
    }
    docNumber = "$docNumber-$strId";
    myDocNo = docNumber;
    return docNumber;
  }

  Future<void> onCashInSave(
      SaveCashinPressed event, Emitter<CashinState> emit) async {
    CashinRepoImpl cashinRepoImpl = CashinRepoImpl();
    await cashinRepoImpl.createCashIn(
        invoice: event.cashinModel,
        tableName: DatabaseConstants.cashinHeadTable);
    await cashinRepoImpl.createCashInDtl(
        cashinDtl: CashInDtl(
            accountid: event.cashinModel.accId,
            amount: event.cashinModel.net1,
            descr: event.cashinModel.descr));
    emit(CashInSavedSuccessfuly());
  }
}
