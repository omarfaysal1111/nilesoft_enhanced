import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';

class InvoiceState {}

class InvoiceInitial extends InvoiceState {}

class InvoicePageInitial extends InvoiceState {}

class InvoicePageLoading extends InvoiceState {}

class InvoiceLoading extends InvoiceState {}

class EditState extends InvoiceState {
  final SalesDtlModel salesDtlModel;
  final int index;
  final List<ItemsModel> items;
  EditState(
      {required this.salesDtlModel, required this.index, required this.items});
}

class InvoiceError extends InvoiceState {
  final String message;

  InvoiceError(this.message);
}

class SaveSuccess extends InvoiceState {}

class DiscountChanged extends InvoiceState {
  final double ratio;
  final double amount;

  DiscountChanged({required this.ratio, required this.amount});
}

class SaveClickedState extends InvoiceState {
  final SalesHeadModel salesHeadModel;
  final List<SalesDtlModel> salesDtlModel;

  SaveClickedState({required this.salesHeadModel, required this.salesDtlModel});
}

class DiscountRatioChanged extends InvoiceState {
  final double ratio;
  final double amount;

  DiscountRatioChanged({required this.ratio, required this.amount});
}

class InvoiceLoaded extends InvoiceState {
  final List<ItemsModel> clients; // Available clients
  final ItemsModel? selectedClient;

  InvoiceLoaded({required this.clients, this.selectedClient});
}

class InvoiceEdittedState extends InvoiceState {
  final SalesDtlModel editedItem;
  final int index;

  InvoiceEdittedState({required this.editedItem, required this.index});
}

class InvoicePageLoaded extends InvoiceState {
  final List<CustomersModel> customers;
  final CustomersModel? selectedCustomer;
  InvoicePageLoaded({required this.customers, this.selectedCustomer});
}

class AddNewInvoiceState extends InvoiceState {
  final List<SalesDtlModel> chosenItems; // Chosen clients for the invoice

  AddNewInvoiceState({required this.chosenItems});
}
