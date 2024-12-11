import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/remote/remote_repositories/remote_customer_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/remote/remote_repositories/remote_invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/remote/remote_repositories/remote_item_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/items_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<UpdatingSumbittedEvent>((event, emit) async {
      try {
        emit(state.copyWith(isUpdateSubmitted: true, isUpdateSucc: false));

        // emit(state.copyWith(isUpdateSubmitted: true));
        RemoteItemRepoImpl itemsRepo = RemoteItemRepoImpl();
        RemoteCustomerRepoImpl customersRepo = RemoteCustomerRepoImpl();
        CustomersRepoImpl customerlocal = CustomersRepoImpl();
        ItemsRepoImpl itemlocal = ItemsRepoImpl();
        List<ItemsModel> items = await itemsRepo.getAllItems();
        await itemlocal.deleteAllItems(tableName: DatabaseConstants.itemsTable);
        await itemlocal.addAllItems(
            items: items, tableName: DatabaseConstants.itemsTable);
        await customerlocal.deleteAllCustomers(
            tableName: DatabaseConstants.customersTable);
        List<CustomersModel> customers = await customersRepo.getAllCustomers();
        await customerlocal.addAllCustomers(
            customers: customers, tableName: DatabaseConstants.customersTable);
        emit(state.copyWith(isUpdateSubmitted: false, isUpdateSucc: true));
      } catch (e) {
        throw Exception(e);
      }
    });
    on<SenddingSumbittedEvent>((event, emit) async {
      emit(state.copyWith(isSendingSubmitted: true, isSendingSucc: false));
      RemoteInvoiceRepoImpl remoteInvoiceRepoImpl = RemoteInvoiceRepoImpl();
      remoteInvoiceRepoImpl.sendInvoices(
          headTableName: DatabaseConstants.salesInvoiceHeadTable,
          dtlTableName: DatabaseConstants.salesInvoiceDtlTable,
          endPoint: "salesinvoice/addnew");
      emit(state.copyWith(isSendingSubmitted: false, isSendingSucc: true));
    });
  }
}
