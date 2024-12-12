import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';

abstract class InvoiceEvent {}

class FetchClientsEvent extends InvoiceEvent {}

class FetchCustomersEvent extends InvoiceEvent {}

class InitializeDataEvent extends InvoiceEvent {
  InitializeDataEvent();
}

class OnInvoiceToEdit extends InvoiceEvent {
  final int id;

  OnInvoiceToEdit(this.id);
}

class EditPressed extends InvoiceEvent {
  final SalesDtlModel salesDtlModel;
  final int index;

  EditPressed({required this.salesDtlModel, required this.index});
}

class OnUpdateInvoice extends InvoiceEvent {
  final SalesHeadModel headModel;
  final List<SalesDtlModel> dtlModel;

  OnUpdateInvoice({required this.headModel, required this.dtlModel});
}

class ClientSelectedEvent extends InvoiceEvent {
  final ItemsModel selectedClient;

  ClientSelectedEvent(this.selectedClient);
}

class SaveButtonClicked extends InvoiceEvent {
  final SalesHeadModel salesHeadModel;
  final List<SalesDtlModel> salesDtlModel;

  SaveButtonClicked(
      {required this.salesHeadModel, required this.salesDtlModel});
}

class OnDiscountChanged extends InvoiceEvent {
  final double amount;
  final double ratio;
  final double price;

  OnDiscountChanged(this.price, {required this.amount, required this.ratio});
}

class OnDiscountRatioChanged extends InvoiceEvent {
  final double amount;
  final double ratio;
  final double price;

  OnDiscountRatioChanged(
      {required this.amount, required this.ratio, required this.price});
}

class AddClientToInvoiceEvent extends InvoiceEvent {
  final SalesDtlModel item;

  AddClientToInvoiceEvent(this.item);
}

class EditInvoiceItemEvent extends InvoiceEvent {
  final SalesDtlModel updatedItem;
  final int index;
  EditInvoiceItemEvent(this.updatedItem, this.index);
}

class InvoicePageLoded extends InvoiceEvent {}

class CustomerSelectedEvent extends InvoiceEvent {
  final CustomersModel selectedCustomer;

  CustomerSelectedEvent({required this.selectedCustomer});
}

class RemoveClientFromInvoiceEvent extends InvoiceEvent {
  final ItemsModel client;

  RemoveClientFromInvoiceEvent(this.client);
}
