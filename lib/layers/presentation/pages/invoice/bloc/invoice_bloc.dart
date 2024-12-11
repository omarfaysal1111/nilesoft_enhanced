import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/items_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/invoice/bloc/invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final List<SalesDtlModel> chosenItems =
      []; // Central storage of chosen clients
  String myDocNo = "";
  InvoiceBloc() : super(InvoiceInitial()) {
    on<SaveButtonClicked>(_onSaveClicked);
    on<FetchClientsEvent>(_onFetchClients);
    on<ClientSelectedEvent>(_onClientSelected);
    on<AddClientToInvoiceEvent>(_onAddClientToInvoice);
    on<FetchCustomersEvent>(_onFetchCutomers);
    on<CustomerSelectedEvent>(_onCutomersSelected);
    on<InitializeDataEvent>((event, emit) async {
      add(FetchClientsEvent());
      add(FetchCustomersEvent());
    });
    on<OnDiscountChanged>(_onDisChanged);
    on<OnDiscountRatioChanged>(_onDisRatioChanged);
    on<EditPressed>(_onEditPressed);
    on<EditInvoiceItemEvent>(_onEdit);
    on<OnInvoiceToEdit>(_onInvoiceToEdit);
    on<OnUpdateInvoice>(_onUpdatingInvoice);
  }
  Future<void> _onEditPressed(
      EditPressed event, Emitter<InvoiceState> emit) async {
    ItemsRepoImpl customersRepoImpl = ItemsRepoImpl();
    List<ItemsModel> items = await customersRepoImpl.getItems(
        tableName: DatabaseConstants.itemsTable);
    emit(EditState(
        index: event.index, salesDtlModel: event.salesDtlModel, items: items));
  }

  void _onEdit(EditInvoiceItemEvent event, Emitter<InvoiceState> emit) {
    if (chosenItems.isEmpty) {
      chosenItems.add(event.updatedItem);
    } else {
      chosenItems[event.index] = event.updatedItem;
    }
    emit(AddNewInvoiceState(
      chosenItems: chosenItems,
    )); // Emit updated state
  }

  Future<void> _onFetchClients(
      FetchClientsEvent event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    try {
      ItemsRepoImpl customersRepoImpl = ItemsRepoImpl();
      List<ItemsModel> items = await customersRepoImpl.getItems(
          tableName: DatabaseConstants.itemsTable);

      emit(InvoiceLoaded(clients: items));
    } catch (error) {
      emit(InvoiceError("Failed to fetch clients"));
    }
  }

  Future<void> _onSaveClicked(
      SaveButtonClicked event, Emitter<InvoiceState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    await invoiceRepoImpl.addInvoiceHead(
        invoiceHead: event.salesHeadModel,
        tableName: DatabaseConstants.salesInvoiceHeadTable);
    await invoiceRepoImpl.addInvoiceDtl(
        invoiceDtl: event.salesDtlModel,
        tableName: DatabaseConstants.salesInvoiceDtlTable);

    emit(SaveSuccess());
  }

  Future<void> _onFetchCutomers(
      FetchCustomersEvent event, Emitter<InvoiceState> emit) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseConstants.startDB(dbHelper);
    emit(InvoicePageLoading());
    try {
      CustomersRepoImpl customersRepoImpl = CustomersRepoImpl();
      List<CustomersModel> customers = await customersRepoImpl.getCustomers(
          tableName: DatabaseConstants.customersTable);
      String s2 =
          "SELECT MAX(id) as latestId FROM ${DatabaseConstants.salesInvoiceHeadTable}";
      List<Map<String, Object?>> queryResult2 = await dbHelper.db.rawQuery(s2);
      int id = 1;
      if (queryResult2[0]["latestId"].toString() == "null" ||
          queryResult2[0]["latestId"].toString() == "" ||
          // ignore: unnecessary_null_comparison
          queryResult2[0]["latestId"].toString() == null) {
        id = 1;
      } else {
        id += int.parse(queryResult2[0]["latestId"].toString().trim());
      }
      emit(InvoicePageLoaded(
          customers: customers, docNo: await generateDocNumber(), id: id));
    } catch (error) {
      emit(InvoiceError("Failed to fetch clients"));
    }
  }

  Future<void> _onInvoiceToEdit(
      OnInvoiceToEdit event, Emitter<InvoiceState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    SalesHeadModel? salesHeadModel = await invoiceRepoImpl.getSingleInvoiceHead(
        tableName: DatabaseConstants.salesInvoiceHeadTable, id: event.id);
    List<SalesDtlModel>? salesDtlModel =
        await invoiceRepoImpl.getSingleInvoiceDtl(
            tableName: DatabaseConstants.salesInvoiceDtlTable,
            id: event.id.toString());
    emit(InvoiceToEdit(
        salesDtlModel: salesDtlModel!, salesHeadModel: salesHeadModel!));
  }

  Future<void> _onCutomersSelected(
      CustomerSelectedEvent event, Emitter<InvoiceState> emit) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseConstants.startDB(dbHelper);

    final currentState = state;
    if (currentState is InvoicePageLoaded) {
      String s2 =
          "SELECT MAX(id) as latestId FROM ${DatabaseConstants.salesInvoiceHeadTable}";
      List<Map<String, Object?>> queryResult2 = await dbHelper.db.rawQuery(s2);
      int id = 1;
      if (queryResult2[0]["latestId"].toString() == "null" ||
          queryResult2[0]["latestId"].toString() == "" ||
          // ignore: unnecessary_null_comparison
          queryResult2[0]["latestId"].toString() == null) {
        id = 1;
      } else {
        id += int.parse(queryResult2[0]["latestId"].toString().trim());
      }
      emit(InvoicePageLoaded(
          customers: currentState.customers,
          selectedCustomer: event.selectedCustomer,
          id: id,
          docNo: await generateDocNumber()));
    }
  }

  Future<void> _onUpdatingInvoice(
      OnUpdateInvoice event, Emitter<InvoiceState> emit) async {
    emit(UpdatingInvoice());
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    await invoiceRepoImpl.updateSalesHead(
        head: event.headModel,
        tableName: DatabaseConstants.salesInvoiceHeadTable);
    await invoiceRepoImpl.updateSalesDtl(
        dtl: event.dtlModel, tableName: DatabaseConstants.salesInvoiceDtlTable);
    emit(UpdateSucc());
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

  void _onClientSelected(
      ClientSelectedEvent event, Emitter<InvoiceState> emit) {
    final currentState = state;
    if (currentState is InvoiceLoaded) {
      emit(InvoiceLoaded(
        clients: currentState.clients,
        selectedClient: event.selectedClient,
      ));
    }
  }

  void _onDisChanged(OnDiscountChanged event, Emitter<InvoiceState> emit) {
    double amount = 0, ratio = 0;

    amount = event.amount;
    ratio = (amount / event.price) * 100;

    emit(DiscountChanged(ratio: ratio, amount: amount));
  }

  void _onDisRatioChanged(
      OnDiscountRatioChanged event, Emitter<InvoiceState> emit) {
    double amount = 0, ratio = 0;

    ratio = event.ratio;
    amount = ratio / 100 * event.price;

    emit(DiscountChanged(ratio: ratio, amount: amount));
  }

  void _onAddClientToInvoice(
      AddClientToInvoiceEvent event, Emitter<InvoiceState> emit) {
    chosenItems.add(event.item); // Update the central list
    emit(AddNewInvoiceState(
      chosenItems: chosenItems,
    )); // Emit updated state
  }
}
