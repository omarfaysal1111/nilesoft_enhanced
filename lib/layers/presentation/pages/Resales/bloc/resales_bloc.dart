import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/items_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_state.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_event.dart';

class ResalesBloc extends Bloc<ResalesEvent, ResalesState> {
  List<SalesDtlModel> chosenItems = []; // Central storage of chosen items
  String myDocNo = "";
  ResalesBloc() : super(ResalesInitial()) {
    // Registering event handlers
    on<ReSaveButtonClicked>(_onSaveClicked);
    on<ReFetchClientsEvent>(_onFetchClients);
    on<ReClientSelectedEvent>(_onClientSelected);
    on<ReAddClientToResalesEvent>(_onAddClientToResales);
    on<ReFetchCustomersEvent>(_onFetchCustomers);
    on<ReCustomerSelectedEvent>(_onCustomerSelected);
    on<ReInitializeDataEvent>(_onInitializeData);
    on<ReOnDiscountChanged>(_onDiscountChanged);
    on<ReOnDiscountRatioChanged>(_onDiscountRatioChanged);
    on<ReEditPressed>(_onEditPressed);
    on<ReOnDeleteCard>(_onDeleteCard);
    on<ReEditResalesItemEvent>(_onEditItem);
    on<OnResaleToEdit>(_onInvoiceToEdit);
    on<OnUpdateResale>(_onUpdatingInvoice);
    on<OnSelectCheckBox>(_onCheckBoxSelected);
    on<ReStartScanning>((event, emit) => emit(QRCodeScanning()));
    on<ReQRCodeDetected>(_onDetect);
    on<OnDisamChanged>(_onDisamChanged);
    on<OnDisratChanged>(_onDisratChanged);
  }
  void _onDisamChanged(OnDisamChanged event, Emitter<ResalesState> emit) {
    double disratVal = 0;
    double net = 0;
    disratVal = (event.value / (event.total - event.previousDis)) * 100;
    net = event.net;
    emit(DisamChanged(net, amValue: event.value, ratValue: disratVal));
  }

  void _onDisratChanged(OnDisratChanged event, Emitter<ResalesState> emit) {
    double disamVal = 0;
    double net = 0;
    disamVal = (event.value / 100) * (event.total - event.previousDis);
    net = event.net;
    emit(DisamChanged(net, amValue: disamVal, ratValue: event.value));
  }

  Future<void> _onDetect(
      ReQRCodeDetected event, Emitter<ResalesState> emit) async {
    ItemsRepoImpl itemsRepoImpl = ItemsRepoImpl();
    ItemsModel itemsModel = await itemsRepoImpl.getItemByBarcode(
        barcode: event.qrCode, tableName: DatabaseConstants.itemsTable);
    emit(QRCodeSuccess(event.qrCode, itemsModel));
  }

  Future<void> _onCheckBoxSelected(
      OnSelectCheckBox event, Emitter<ResalesState> emit) async {
    emit(CheckBoxSelected(value: event.value));
  }

  Future<void> _onUpdatingInvoice(
      OnUpdateResale event, Emitter<ResalesState> emit) async {
    emit(UpdatingResale());
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    int id = await invoiceRepoImpl.updateSalesHead(
        head: event.headModel,
        tableName: DatabaseConstants.reSaleInvoiceHeadTable);
    for (var i = 0; i < event.dtlModel.length; i++) {
      event.dtlModel[i].id = event.headModel.id.toString();
    }
    await invoiceRepoImpl.updateSalesDtl(
        dtl: event.dtlModel,
        tableName: DatabaseConstants.reSaleInvoiceDtlTable);
    emit(ResaleUpdateSucc());
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
        "SELECT MAX(id) as latestId FROM ${DatabaseConstants.reSaleInvoiceHeadTable}";
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

  Future<void> _onFetchClients(
      ReFetchClientsEvent event, Emitter<ResalesState> emit) async {
    emit(ResalesLoading());
    try {
      ItemsRepoImpl itemsRepo = ItemsRepoImpl();
      List<ItemsModel> clients =
          await itemsRepo.getItems(tableName: DatabaseConstants.itemsTable);
      emit(ResalesLoaded(clients: clients));
    } catch (error) {
      emit(ResalesError("Failed to fetch clients"));
    }
  }

  Future<void> _onSaveClicked(
      ReSaveButtonClicked event, Emitter<ResalesState> emit) async {
    try {
      InvoiceRepoImpl invoiceRepo = InvoiceRepoImpl();
      int id = await invoiceRepo.addInvoiceHead(
          invoiceHead: event.salesHeadModel,
          tableName: DatabaseConstants.reSaleInvoiceHeadTable);

      for (var i = 0; i < event.salesDtlModel.length; i++) {
        event.salesDtlModel[i].id = id.toString();
      }
      await invoiceRepo.addInvoiceDtl(
          invoiceDtl: event.salesDtlModel,
          tableName: DatabaseConstants.reSaleInvoiceDtlTable);

      emit(ReSaveSuccess());
    } catch (error) {
      emit(ResalesError("Failed to save invoice"));
    }
  }

  Future<void> _onInvoiceToEdit(
      OnResaleToEdit event, Emitter<ResalesState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    SalesHeadModel? salesHeadModel = await invoiceRepoImpl.getSingleInvoiceHead(
        tableName: DatabaseConstants.reSaleInvoiceHeadTable, id: event.id);
    List<SalesDtlModel>? salesDtlModel =
        await invoiceRepoImpl.getSingleInvoiceDtl(
            tableName: DatabaseConstants.reSaleInvoiceDtlTable,
            id: event.id.toString());
    CustomersRepoImpl customersRepo = CustomersRepoImpl();
    List<CustomersModel> customers = await customersRepo.getCustomers(
        tableName: DatabaseConstants.customersTable);
    emit(ResaleToEdit(
        salesDtlModel: salesDtlModel!,
        salesHeadModel: salesHeadModel!,
        customers: customers));
  }

  void _onDeleteCard(ReOnDeleteCard event, Emitter<ResalesState> emit) {
    emit(ReCardDeleted());
  }

  Future<void> _onFetchCustomers(
      ReFetchCustomersEvent event, Emitter<ResalesState> emit) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseConstants.startDB(dbHelper);
    emit(ResalesPageLoading());
    try {
      CustomersRepoImpl customersRepo = CustomersRepoImpl();
      List<CustomersModel> customers = await customersRepo.getCustomers(
          tableName: DatabaseConstants.customersTable);
      String s2 =
          "SELECT MAX(id) as latestId FROM ${DatabaseConstants.reSaleInvoiceHeadTable}";
      List<Map<String, Object?>> queryResult2 = await dbHelper.db.rawQuery(s2);
      int id = 1;
      if (queryResult2[0]["latestId"].toString() == "null" ||
          queryResult2[0]["latestId"].toString() == "" ||
          // ignore: unnecessary_null_comparison
          queryResult2[0]["latestId"].toString() == null) {
        id = 1;
      } else {
        id = int.parse(queryResult2[0]["latestId"].toString().trim());
        id = id + 1;
      }
      emit(ResalesPageLoaded(
          customers: customers, docNo: await generateDocNumber(), id: id));
    } catch (error) {
      emit(ResalesError("Failed to fetch customers"));
    }
  }

  Future<void> _onCustomerSelected(
      ReCustomerSelectedEvent event, Emitter<ResalesState> emit) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseConstants.startDB(dbHelper);
    final currentState = state;
    if (currentState is ResalesPageLoaded) {
      String s2 =
          "SELECT MAX(id) as latestId FROM ${DatabaseConstants.reSaleInvoiceHeadTable}";
      List<Map<String, Object?>> queryResult2 = await dbHelper.db.rawQuery(s2);
      int id = 1;
      if (queryResult2[0]["latestId"].toString() == "null" ||
          queryResult2[0]["latestId"].toString() == "" ||
          // ignore: unnecessary_null_comparison
          queryResult2[0]["latestId"].toString() == null) {
        id = 1;
      } else {
        id = int.parse(queryResult2[0]["latestId"].toString().trim());
        id = id + 1;
      }
      emit(ResalesPageLoaded(
        customers: currentState.customers,
        id: id,
        docNo: await generateDocNumber(),
        selectedCustomer: event.selectedCustomer,
      ));
    }
  }

  void _onClientSelected(
      ReClientSelectedEvent event, Emitter<ResalesState> emit) {
    final currentState = state;
    if (currentState is ResalesLoaded) {
      emit(ResalesLoaded(
        clients: currentState.clients,
        selectedClient: event.selectedClient,
      ));
    }
  }

  void _onDiscountChanged(
      ReOnDiscountChanged event, Emitter<ResalesState> emit) {
    double amount = event.amount;
    double ratio = (amount / event.price) * 100;

    emit(ReDiscountChanged(ratio: ratio, amount: amount));
  }

  void _onDiscountRatioChanged(
      ReOnDiscountRatioChanged event, Emitter<ResalesState> emit) {
    double ratio = event.ratio;
    double amount = ratio / 100 * event.price;

    emit(ReDiscountChanged(ratio: ratio, amount: amount));
  }

  void _onAddClientToResales(
      ReAddClientToResalesEvent event, Emitter<ResalesState> emit) {
    chosenItems = event.allDtl;
    chosenItems.add(event.item); // Update the central list
    emit(AddNewResalesState(chosenItems: chosenItems));
  }

  Future<void> _onEditPressed(
      ReEditPressed event, Emitter<ResalesState> emit) async {
    try {
      ItemsRepoImpl itemsRepo = ItemsRepoImpl();
      List<ItemsModel> items =
          await itemsRepo.getItems(tableName: DatabaseConstants.itemsTable);
      emit(ReEditState(
          index: event.index,
          salesDtlModel: event.salesDtlModel,
          items: items));
    } catch (error) {
      emit(ResalesError("Failed to fetch items for editing"));
    }
  }

  void _onEditItem(ReEditResalesItemEvent event, Emitter<ResalesState> emit) {
    if (chosenItems.isEmpty) {
      chosenItems.add(event.updatedItem);
    } else {
      chosenItems[event.index] = event.updatedItem;
    }
    emit(AddNewResalesState(
      chosenItems: chosenItems,
    )); // Emit updated state
  }

  Future<void> _onInitializeData(
      ReInitializeDataEvent event, Emitter<ResalesState> emit) async {
    emit(ResalesInitial());
    add(ReFetchClientsEvent());
    add(ReFetchCustomersEvent());
  }
}
