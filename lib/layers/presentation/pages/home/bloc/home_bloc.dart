import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/local_areas_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/areas_repo_model_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/remote_cashin_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/models/city.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/remote_customer_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/remote_invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/remote_item_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/customers_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/items_repo_impl.dart';
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
        AreasRepoModelImpl areasRepoModelImpl = AreasRepoModelImpl();
        LocalsAreasRepoImpl localsAreasRepoImpl = LocalsAreasRepoImpl();
        List<CityModel> cities = await areasRepoModelImpl.getCities();
        List<CityModel> areas = await areasRepoModelImpl.getAreas();
        List<CityModel> govs = await areasRepoModelImpl.getGovs();
        localsAreasRepoImpl.deleteAllAreas(tableName: 'areas');
        localsAreasRepoImpl.deleteAllAreas(tableName: 'cities');
        localsAreasRepoImpl.deleteAllAreas(tableName: 'govs');
        localsAreasRepoImpl.addAllAreas(areas: areas, tableName: 'areas');
        localsAreasRepoImpl.addAllAreas(areas: cities, tableName: 'cities');
        localsAreasRepoImpl.addAllAreas(areas: govs, tableName: 'govs');

        emit(state.copyWith(isUpdateSubmitted: false, isUpdateSucc: true));
      } catch (e) {
        throw Exception(e);
      }
    });
    on<SenddingSumbittedEvent>((event, emit) async {
      emit(state.copyWith(isSendingSubmitted: true, isSendingSucc: false));
      //Send Sales Invoices
      RemoteInvoiceRepoImpl remoteInvoiceRepoImpl = RemoteInvoiceRepoImpl();
      remoteInvoiceRepoImpl.sendInvoices(
          headTableName: DatabaseConstants.salesInvoiceHeadTable,
          dtlTableName: DatabaseConstants.salesInvoiceDtlTable,
          endPoint: "salesinvoice/addnew");
      //Send Resales Invoice
      remoteInvoiceRepoImpl.sendInvoices(
          headTableName: DatabaseConstants.reSaleInvoiceHeadTable,
          dtlTableName: DatabaseConstants.reSaleInvoiceDtlTable,
          endPoint: "rsalesinvoice/addnew");
      RemoteCashinRepoImpl remoteCashinRepoImpl = RemoteCashinRepoImpl();
      remoteCashinRepoImpl.sendInvoices(
          endPoint: "cashin/addnew",
          headTableName: DatabaseConstants.cashinHeadTable);
      emit(state.copyWith(isSendingSubmitted: false, isSendingSucc: true));
    });
  }
}
