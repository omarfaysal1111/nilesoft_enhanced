import 'package:flutter_bloc/flutter_bloc.dart';
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

    on<EditInvoiceItemEvent>((event, emit) {});
  }
  void _onEditPressed(EditPressed event, Emitter<InvoiceState> emit) {
    emit(EditState(index: event.index, salesDtlModel: event.salesDtlModel));
  }

  Future<void> _onFetchClients(
      FetchClientsEvent event, Emitter<InvoiceState> emit) async {
    emit(InvoiceLoading());
    try {
      ItemsRepoImpl customersRepoImpl = ItemsRepoImpl();
      List<ItemsModel> customers = await customersRepoImpl.getItems(
          tableName: DatabaseConstants.itemsTable);
      emit(InvoiceLoaded(clients: customers));
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
    emit(InvoicePageLoading());
    try {
      CustomersRepoImpl customersRepoImpl = CustomersRepoImpl();
      List<CustomersModel> customers = await customersRepoImpl.getCustomers(
          tableName: DatabaseConstants.customersTable);
      emit(InvoicePageLoaded(customers: customers));
    } catch (error) {
      emit(InvoiceError("Failed to fetch clients"));
    }
  }

  void _onCutomersSelected(
      CustomerSelectedEvent event, Emitter<InvoiceState> emit) {
    final currentState = state;
    if (currentState is InvoicePageLoaded) {
      emit(InvoicePageLoaded(
        customers: currentState.customers,
        selectedCustomer: event.selectedCustomer,
      ));
    }
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
