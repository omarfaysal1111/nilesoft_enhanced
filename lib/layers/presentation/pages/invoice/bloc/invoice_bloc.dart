import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/items_repo_impl.dart';
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
    on<OnDeleteCard>(_onDeleteCard);
    on<InitializeDataEvent>((event, emit) async {
      emit(InvoiceInitial());
      add(FetchClientsEvent());
      add(FetchCustomersEvent());
    });
    on<OnDiscountChanged>(_onDisChanged);
    on<OnDiscountRatioChanged>(_onDisRatioChanged);
    on<EditPressed>(_onEditPressed);
    on<EditInvoiceItemEvent>(_onEdit);
    on<OnInvoiceToEdit>(_onInvoiceToEdit);
    on<OnUpdateInvoice>(_onUpdatingInvoice);
    on<SearchClientsEvent>(_onSearchClientsEvent);
    on<OnTextTapped>(_onTextTapped);
    on<OnSelectCheckBox>(_onCheckBoxSelected);
    on<StartScanning>((event, emit) => emit(QRCodeScanning()));
    on<QRCodeDetected>(_onDetect);
    on<QRCodeError>((event, emit) => emit(QRCodeFailure(event.error)));
    on<OnDisamChanged>(_onDisamChanged);
    on<OnDisratChanged>(_onDisratChanged);
  }

  void _onDisamChanged(OnDisamChanged event, Emitter<InvoiceState> emit) {
    double disratVal = 0;
    double net = 0;
    disratVal = (event.value / (event.total - event.previousDis)) * 100;
    net = event.net;
    emit(DisamChanged(net, amValue: event.value, ratValue: disratVal));
  }

  void _onDisratChanged(OnDisratChanged event, Emitter<InvoiceState> emit) {
    double disamVal = 0;
    double net = 0;
    disamVal = (event.value / 100) * (event.total - event.previousDis);
    net = event.net;
    emit(DisamChanged(net, amValue: disamVal, ratValue: event.value));
  }

  Future<void> _onCheckBoxSelected(
      OnSelectCheckBox event, Emitter<InvoiceState> emit) async {
    emit(CheckBoxSelected(value: event.value));
  }

  Future<void> _onDetect(
      QRCodeDetected event, Emitter<InvoiceState> emit) async {
    ItemsRepoImpl itemsRepoImpl = ItemsRepoImpl();
    ItemsModel itemsModel = await itemsRepoImpl.getItemByBarcode(
        barcode: event.qrCode, tableName: DatabaseConstants.itemsTable);
    emit(QRCodeSuccess(event.qrCode, itemsModel));
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

  void _onDeleteCard(OnDeleteCard event, Emitter<InvoiceState> emit) {
    emit(CardDeleted());
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
    DatabaseHelper databaseHelper = DatabaseHelper();
    DatabaseConstants.startDB(databaseHelper);

    await invoiceRepoImpl.addInvoiceHead(
        invoiceHead: event.salesHeadModel,
        tableName: DatabaseConstants.salesInvoiceHeadTable);
    await invoiceRepoImpl.addInvoiceDtl(
        invoiceDtl: event.salesDtlModel,
        tableName: DatabaseConstants.salesInvoiceDtlTable);
    int len = await databaseHelper
        .checkSerialNo(event.salesDtlModel[0].id.toString());
    if (len == 0) {
      emit(SaveSuccess());
    } else {
      emit(HasSerialState(len: len));
    }
  }

  void _onSearchClientsEvent(
      SearchClientsEvent event, Emitter<InvoiceState> emit) {
    final currentState = state;
    if (currentState is InvoicePageLoaded) {
      // Filter the client list based on the search query
      List<CustomersModel> filteredClients = currentState.customers
          .where((client) =>
              client.name!.toLowerCase().contains(event.query.toLowerCase()))
          .toList();

      emit(InvoiceFiltered(filteredClients: filteredClients));
    }
  }

/* 

select sum(salesInvoiceDtl.qty) as Qty from salesInvoiceDtl where id = '11' inner join items on salesInvoiceDtl.itemId = items.itemid and items.hasSerial=1"
E/flutter (20811): [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: DatabaseException(near "inner": syntax error (code 1 SQLITE_ERROR): , while compiling: select sum(salesInvoiceDtl.qty) as Qty from salesInvoiceDtl where id = '11' inner join items on salesInvoiceDtl.itemId = items.itemid and items.hasSerial=1) sql 'select sum(salesInvoiceDtl.qty) as Qty from salesInvoiceDtl where id = '11' inner join items on salesInvoiceDtl.itemId = items.itemid and items.hasSerial=1
*/

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
    CustomersRepoImpl customersRepoImpl = CustomersRepoImpl();
    List<CustomersModel> customers = await customersRepoImpl.getCustomers(
        tableName: DatabaseConstants.customersTable);
    emit(InvoiceToEdit(
        salesDtlModel: salesDtlModel!,
        salesHeadModel: salesHeadModel!,
        customers: customers));
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

  Future<void> _onTextTapped(
      OnTextTapped event, Emitter<InvoiceState> emit) async {
    emit(TextFoucsed(controller: event.controller));
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
