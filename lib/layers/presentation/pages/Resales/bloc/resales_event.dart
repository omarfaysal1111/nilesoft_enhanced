import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';

abstract class ResalesEvent {}

class ReFetchClientsEvent extends ResalesEvent {}

class ReFetchCustomersEvent extends ResalesEvent {}

class ReInitializeDataEvent extends ResalesEvent {
  ReInitializeDataEvent();
}

class ReEditPressed extends ResalesEvent {
  final SalesDtlModel salesDtlModel;
  final int index;

  ReEditPressed({required this.salesDtlModel, required this.index});
}

class ReClientSelectedEvent extends ResalesEvent {
  final ItemsModel selectedClient;

  ReClientSelectedEvent(this.selectedClient);
}

class ReSaveButtonClicked extends ResalesEvent {
  final SalesHeadModel salesHeadModel;
  final List<SalesDtlModel> salesDtlModel;

  ReSaveButtonClicked(
      {required this.salesHeadModel, required this.salesDtlModel});
}

class ReOnDiscountChanged extends ResalesEvent {
  final double amount;
  final double ratio;
  final double price;

  ReOnDiscountChanged(this.price, {required this.amount, required this.ratio});
}

class ReOnDiscountRatioChanged extends ResalesEvent {
  final double amount;
  final double ratio;
  final double price;

  ReOnDiscountRatioChanged(
      {required this.amount, required this.ratio, required this.price});
}

class ReAddClientToResalesEvent extends ResalesEvent {
  final SalesDtlModel item;

  ReAddClientToResalesEvent(this.item);
}

class ReEditResalesItemEvent extends ResalesEvent {
  final SalesDtlModel updatedItem;
  final int index;
  ReEditResalesItemEvent(this.updatedItem, this.index);
}

class ResalesPageLoded extends ResalesEvent {}

class ReCustomerSelectedEvent extends ResalesEvent {
  final CustomersModel selectedCustomer;

  ReCustomerSelectedEvent({required this.selectedCustomer});
}

class RemoveClientFromResalesEvent extends ResalesEvent {
  final ItemsModel client;

  RemoveClientFromResalesEvent(this.client);
}
