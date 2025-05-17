import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';

class ResalesState {}

class ResalesInitial extends ResalesState {}

class ResalesPageInitial extends ResalesState {}

class ResalesPageLoading extends ResalesState {}

class ResalesLoading extends ResalesState {}

class ReEditState extends ResalesState {
  final SalesDtlModel salesDtlModel;
  final int index;
  final List<ItemsModel> items;
  ReEditState(
      {required this.salesDtlModel, required this.index, required this.items});
}

class ResalesError extends ResalesState {
  final String message;

  ResalesError(this.message);
}

class ReSaveSuccess extends ResalesState {}

class ReDiscountChanged extends ResalesState {
  final double ratio;
  final double amount;

  ReDiscountChanged({required this.ratio, required this.amount});
}

class ReSaveClickedState extends ResalesState {
  final SalesHeadModel salesHeadModel;
  final List<SalesDtlModel> salesDtlModel;

  ReSaveClickedState(
      {required this.salesHeadModel, required this.salesDtlModel});
}

class ReDiscountRatioChanged extends ResalesState {
  final double ratio;
  final double amount;

  ReDiscountRatioChanged({required this.ratio, required this.amount});
}

class ResalesLoaded extends ResalesState {
  final List<ItemsModel> clients; // Available clients
  final ItemsModel? selectedClient;

  ResalesLoaded({required this.clients, this.selectedClient});
}

class CheckBoxSelected extends ResalesState {
  final String value;

  CheckBoxSelected({required this.value});
}

class DisamChanged extends ResalesState {
  final double amValue;
  final double ratValue;
  final double net;
  DisamChanged(this.net, {required this.amValue, required this.ratValue});
}

class DisratChanged extends ResalesState {
  final double amValue;
  final double ratValue;
  final double net;

  DisratChanged(this.net, {required this.amValue, required this.ratValue});
}

class ReCardDeleted extends ResalesState {}

class QRCodeInitial extends ResalesState {}

class QRCodeScanning extends ResalesState {}

class QRCodeSuccess extends ResalesState {
  final String qrCode;
  final ItemsModel item;
  QRCodeSuccess(this.qrCode, this.item);
}

class QRCodeFailure extends ResalesState {
  final String error;

  QRCodeFailure(this.error);
}

class ResaleToEdit extends ResalesState {
  final List<SalesDtlModel> salesDtlModel;
  final SalesHeadModel salesHeadModel;
  final List<CustomersModel> customers;
  ResaleToEdit(
      {required this.salesDtlModel,
      required this.salesHeadModel,
      required this.customers});
}

class ResaleUpdateSucc extends ResalesState {}

class ResalesEdittedState extends ResalesState {
  final SalesDtlModel editedItem;
  final int index;

  ResalesEdittedState({required this.editedItem, required this.index});
}

class UpdatingResale extends ResalesState {}

class ResalesPageLoaded extends ResalesState {
  final List<CustomersModel> customers;
  final CustomersModel? selectedCustomer;
  final String? docNo;
  final int? id;
  ResalesPageLoaded(
      {required this.customers, this.selectedCustomer, this.docNo, this.id});
}

class AddNewResalesState extends ResalesState {
  final List<SalesDtlModel> chosenItems; // Chosen clients for the Resales

  AddNewResalesState({required this.chosenItems});
}
