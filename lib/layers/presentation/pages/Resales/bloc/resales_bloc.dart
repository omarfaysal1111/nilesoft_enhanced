import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/items_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_state.dart';
import 'package:nilesoft_erp/layers/presentation/pages/Resales/bloc/resales_event.dart';

final List<SalesDtlModel> chosenItems = []; // Central storage of chosen items

class ResalesBloc extends Bloc<ResalesEvent, ResalesState> {
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
    on<ReEditResalesItemEvent>(_onEditItem);
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
      await invoiceRepo.addInvoiceHead(
          invoiceHead: event.salesHeadModel,
          tableName: DatabaseConstants.reSaleInvoiceHeadTable);
      await invoiceRepo.addInvoiceDtl(
          invoiceDtl: event.salesDtlModel,
          tableName: DatabaseConstants.reSaleInvoiceDtlTable);

      emit(ReSaveSuccess());
    } catch (error) {
      emit(ResalesError("Failed to save invoice"));
    }
  }

  Future<void> _onFetchCustomers(
      ReFetchCustomersEvent event, Emitter<ResalesState> emit) async {
    emit(ResalesPageLoading());
    try {
      CustomersRepoImpl customersRepo = CustomersRepoImpl();
      List<CustomersModel> customers = await customersRepo.getCustomers(
          tableName: DatabaseConstants.customersTable);
      emit(ResalesPageLoaded(customers: customers));
    } catch (error) {
      emit(ResalesError("Failed to fetch customers"));
    }
  }

  void _onCustomerSelected(
      ReCustomerSelectedEvent event, Emitter<ResalesState> emit) {
    final currentState = state;
    if (currentState is ResalesPageLoaded) {
      emit(ResalesPageLoaded(
        customers: currentState.customers,
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
    chosenItems[event.index] = event.updatedItem;
    emit(AddNewResalesState(chosenItems: chosenItems));
  }

  Future<void> _onInitializeData(
      ReInitializeDataEvent event, Emitter<ResalesState> emit) async {
    add(ReFetchClientsEvent());
    add(ReFetchCustomersEvent());
  }
}
