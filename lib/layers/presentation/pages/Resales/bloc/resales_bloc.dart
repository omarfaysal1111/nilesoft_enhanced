import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/local/sqflite_row_utils.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/settings_repo_impl.dart' show SettingsRepoImpl;
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/items_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/models/settings_model.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_state.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_event.dart';

class ResalesBloc extends Bloc<ResalesEvent, ResalesState> {
  List<SalesDtlModel> chosenItems = []; // Central storage of chosen items
  String myDocNo = "";
  /// Customer account id for the current resale invoice (matches [salesInvoiceHead.accid]).
  String? _resaleCustomerAccId;

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
    // Calculate discount on the total (subtotal), not on (total - previousDis)
    // Customer discount should be applied on the full subtotal
    disamVal = (event.value / 100) * event.total;
    net = event.net;
    emit(DisamChanged(net, amValue: disamVal, ratValue: event.value));
  }

  Future<void> _onDetect(
      ReQRCodeDetected event, Emitter<ResalesState> emit) async {
    ItemsRepoImpl itemsRepoImpl = ItemsRepoImpl();
    ItemsModel itemsModel = await itemsRepoImpl.getItemByBarcode(
        barcode: event.qrCode, tableName: DatabaseConstants.itemsTable);
    final latestPrice = await _getLatestSalesPriceForCustomerItem(
      customerAccId:
          _normalizeAccId(event.customerAccId) ?? _resaleCustomerAccId,
      itemId: itemsModel.itemid,
    );
    if (latestPrice != null) {
      itemsModel.price = latestPrice;
    }
    emit(QRCodeSuccess(event.qrCode, itemsModel));
  }

  /// Latest unit price from [salesInvoiceDtlTable] for this customer and item
  /// (joined to [salesInvoiceHeadTable] on invoice id). Newest sales invoice wins.
  Future<double?> _getLatestSalesPriceForCustomerItem({
    required String? customerAccId,
    required String? itemId,
  }) async {
    final acc = customerAccId?.trim() ?? '';
    final iid = itemId?.trim() ?? '';
    if (acc.isEmpty || iid.isEmpty) {
      return null;
    }

    final dbHelper = DatabaseHelper();
    await DatabaseConstants.startDB(dbHelper);
    final result = await dbHelper.db.rawQuery(
      """
      SELECT dtl.price
      FROM ${DatabaseConstants.salesInvoiceDtlTable} dtl
      INNER JOIN ${DatabaseConstants.salesInvoiceHeadTable} h
        ON TRIM(CAST(h.id AS TEXT)) = TRIM(CAST(IFNULL(dtl.id, '') AS TEXT))
      WHERE TRIM(IFNULL(dtl.itemId, '')) = ?
        AND TRIM(IFNULL(h.accid, '')) = ?
        AND dtl.price IS NOT NULL
      ORDER BY h.id DESC, dtl.innerid DESC
      LIMIT 1
      """,
      [iid, acc],
    );

    if (result.isEmpty || result.first["price"] == null) {
      return null;
    }
    return double.tryParse(result.first["price"].toString());
  }

  Future<void> _onCheckBoxSelected(
      OnSelectCheckBox event, Emitter<ResalesState> emit) async {
    emit(CheckBoxSelected(value: event.value));
  }

  Future<void> _onUpdatingInvoice(
      OnUpdateResale event, Emitter<ResalesState> emit) async {
    emit(UpdatingResale());
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    // ignore: unused_local_variable
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
    final Object? mobileUser = firstSqfliteRowValue(queryResult1, 'm');
    docNumber = "MOB${mobileUser ?? ""}";
    String s2 =
        "SELECT MAX(id) as latestId FROM ${DatabaseConstants.reSaleInvoiceHeadTable}";
    List<Map<String, Object?>> queryResult2 = await dbHelper.db.rawQuery(s2);

    final int? latest = parseLatestIdFromMaxQuery(queryResult2);
    if (latest != null) {
      nextId = latest;
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

    // Retry logic with exponential backoff
    int maxRetries = 10;
    int retryCount = 0;
    Duration delay = const Duration(milliseconds: 500);

    while (retryCount < maxRetries) {
      try {
        ItemsRepoImpl itemsRepo = ItemsRepoImpl();
        List<ItemsModel> clients =
            await itemsRepo.getItems(tableName: DatabaseConstants.itemsTable);
        emit(ResalesLoaded(clients: clients));
        return; // Success, exit retry loop
      } catch (error) {
        retryCount++;
        if (retryCount >= maxRetries) {
          // After max retries, re-emit the event to continue retrying
          await Future.delayed(delay);
          add(ReFetchClientsEvent());
          return;
        }
        // Wait before retrying with exponential backoff
        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
      }
    }
  }

  Future<void> _onSaveClicked(
      ReSaveButtonClicked event, Emitter<ResalesState> emit) async {
    try {
      InvoiceRepoImpl invoiceRepo = InvoiceRepoImpl();
      SettingsRepoImpl settingsRepoImpl = SettingsRepoImpl();
    double maxDis = 0;

    List<SettingsModel> mySettings = await settingsRepoImpl.getSettings(
        tableName: DatabaseConstants.settingsTable);

    maxDis = mySettings[0].maxDis ?? 0;
    
    if (maxDis > 0 && event.salesHeadModel.disratio! > maxDis) {
      emit(ReSaveFailed('الخصم علي الفاتورة اكبر من الحد المسموح به'));
      return;
    }
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
    if (salesHeadModel != null) {
      _resaleCustomerAccId = _normalizeAccId(salesHeadModel.accid);
    }

    emit(ResaleToEdit(
        salesDtlModel: salesDtlModel!,
        salesHeadModel: salesHeadModel!,
        customers: customers));
  }

  static String? _normalizeAccId(String? raw) {
    final t = raw?.trim() ?? '';
    return t.isEmpty ? null : t;
  }

  void _onDeleteCard(ReOnDeleteCard event, Emitter<ResalesState> emit) {
    emit(ReCardDeleted());
  }

  Future<void> _onFetchCustomers(
      ReFetchCustomersEvent event, Emitter<ResalesState> emit) async {
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseConstants.startDB(dbHelper);
    emit(ResalesPageLoading());

    // Retry logic with exponential backoff
    int maxRetries = 10;
    int retryCount = 0;
    Duration delay = const Duration(milliseconds: 500);

    while (retryCount < maxRetries) {
      try {
        CustomersRepoImpl customersRepo = CustomersRepoImpl();
        List<CustomersModel> customers = await customersRepo.getCustomers(
            tableName: DatabaseConstants.customersTable);
        String s2 =
            "SELECT MAX(id) as latestId FROM ${DatabaseConstants.reSaleInvoiceHeadTable}";
        List<Map<String, Object?>> queryResult2 =
            await dbHelper.db.rawQuery(s2);
        final int? latest = parseLatestIdFromMaxQuery(queryResult2);
        final int id = latest != null ? latest + 1 : 1;
        emit(ResalesPageLoaded(
            customers: customers, docNo: await generateDocNumber(), id: id));
        return; // Success, exit retry loop
      } catch (error) {
        retryCount++;
        if (retryCount >= maxRetries) {
          // After max retries, re-emit the event to continue retrying
          await Future.delayed(delay);
          add(ReFetchCustomersEvent());
          return;
        }
        // Wait before retrying with exponential backoff
        await Future.delayed(delay);
        delay = Duration(milliseconds: (delay.inMilliseconds * 1.5).round());
      }
    }
  }

  Future<void> _onCustomerSelected(
      ReCustomerSelectedEvent event, Emitter<ResalesState> emit) async {
    _resaleCustomerAccId = _normalizeAccId(event.selectedCustomer.id);
    DatabaseHelper dbHelper = DatabaseHelper();
    DatabaseConstants.startDB(dbHelper);
    final currentState = state;
    if (currentState is ResalesPageLoaded) {
      String s2 =
          "SELECT MAX(id) as latestId FROM ${DatabaseConstants.reSaleInvoiceHeadTable}";
      List<Map<String, Object?>> queryResult2 = await dbHelper.db.rawQuery(s2);
      final int? latest = parseLatestIdFromMaxQuery(queryResult2);
      final int id = latest != null ? latest + 1 : 1;
      emit(ResalesPageLoaded(
        customers: currentState.customers,
        id: id,
        docNo: await generateDocNumber(),
        selectedCustomer: event.selectedCustomer,
      ));
    }
  }

  Future<void> _onClientSelected(
      ReClientSelectedEvent event, Emitter<ResalesState> emit) async {
    final currentState = state;
    if (currentState is ResalesLoaded) {
      final latestPrice = await _getLatestSalesPriceForCustomerItem(
        customerAccId:
            _normalizeAccId(event.customerAccId) ?? _resaleCustomerAccId,
        itemId: event.selectedClient.itemid,
      );
      if (latestPrice != null) {
        event.selectedClient.price = latestPrice;
      }
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
    _resaleCustomerAccId = null;
    emit(ResalesInitial());
    add(ReFetchClientsEvent());
    add(ReFetchCustomersEvent());
  }
}
