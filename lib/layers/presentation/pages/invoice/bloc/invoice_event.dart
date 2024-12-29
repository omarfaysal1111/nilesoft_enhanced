import 'package:flutter/material.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';

abstract class InvoiceEvent {}

class FetchClientsEvent extends InvoiceEvent {}

class FetchCustomersEvent extends InvoiceEvent {}

class InitializeDataEvent extends InvoiceEvent {
  InitializeDataEvent();
}

class OnSelectCheckBox extends InvoiceEvent {
  final String value;

  OnSelectCheckBox({required this.value});
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
//selextt sum(dtl).qty from

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

class SearchClientsEvent extends InvoiceEvent {
  final String query;

  SearchClientsEvent(this.query);
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

class StartScanning extends InvoiceEvent {}

class QRCodeDetected extends InvoiceEvent {
  final String qrCode;

  QRCodeDetected(this.qrCode);
}

class OnDisamChanged extends InvoiceEvent {
  final double value;
  final double total;
  final double previousDis;
  final double net;
  OnDisamChanged(this.total, this.previousDis, this.net, {required this.value});
}

class OnDisratChanged extends InvoiceEvent {
  final double value;
  final double total;
  final double previousDis;
  final double net;
  OnDisratChanged(this.total, this.previousDis, this.net,
      {required this.value});
}

class QRCodeError extends InvoiceEvent {
  final String error;

  QRCodeError(this.error);
}

class OnTextTapped extends InvoiceEvent {
  final TextEditingController controller;

  OnTextTapped({required this.controller});
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
