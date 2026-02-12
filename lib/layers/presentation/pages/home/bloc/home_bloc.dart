import 'dart:io';

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
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/remote_mobile_item_units_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/mobile_item_units_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState.initial()) {
    on<UpdatingSumbittedEvent>((event, emit) async {
      try {
        emit(state.copyWith(
            isUpdateSubmitted: true, isUpdateSucc: false, errorMessage: null));

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

        // Fetch and store mobile item units
        RemoteMobileItemUnitsRepoImpl mobileItemUnitsRepo =
            RemoteMobileItemUnitsRepoImpl();
        MobileItemUnitsRepoImpl mobileItemUnitsLocal =
            MobileItemUnitsRepoImpl();
        var mobileItemUnits = await mobileItemUnitsRepo.getAllMobileItemUnits();
        await mobileItemUnitsLocal.deleteAllMobileItemUnits(
            tableName: DatabaseConstants.mobileItemUnitsTable);
        await mobileItemUnitsLocal.addAllMobileItemUnits(
            items: mobileItemUnits,
            tableName: DatabaseConstants.mobileItemUnitsTable);

        emit(state.copyWith(
            isUpdateSubmitted: false, isUpdateSucc: true, errorMessage: null));
      } catch (e) {
        final result = await InternetAddress.lookup('google.com');

        String errorMsg = "حدث خطأ أثناء تحديث البيانات";
 if (e.toString().contains("401")) {
   errorMsg = "انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى";
 } else if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
   errorMsg = "فشل الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت";
} else {
errorMsg = e.toString();
}
        emit(state.copyWith(
          isUpdateSubmitted: false,
          isUpdateSucc: false,
          errorMessage: errorMsg,
        ));
      }
    });
    on<SenddingSumbittedEvent>((event, emit) async {
      try {
        emit(state.copyWith(
            isSendingSubmitted: true,
            isSendingSucc: false,
            errorMessage: null));
        // Clear previous messages and reset problems counter at the start
        RemoteInvoiceRepoImpl.messages.clear();
        RemoteInvoiceRepoImpl.problems = 0;

        //Send Sales Invoices
        RemoteInvoiceRepoImpl remoteInvoiceRepoImpl = RemoteInvoiceRepoImpl();
        await remoteInvoiceRepoImpl.sendInvoices(
            headTableName: DatabaseConstants.salesInvoiceHeadTable,
            dtlTableName: DatabaseConstants.salesInvoiceDtlTable,
            endPoint: "salesinvoice/addnew");
        //Send Resales Invoice
        await remoteInvoiceRepoImpl.sendInvoices(
            headTableName: DatabaseConstants.reSaleInvoiceHeadTable,
            dtlTableName: DatabaseConstants.reSaleInvoiceDtlTable,
            endPoint: "rsalesinvoice/addnew");
        RemoteCashinRepoImpl remoteCashinRepoImpl = RemoteCashinRepoImpl();
        await remoteCashinRepoImpl.sendInvoices(
            endPoint: "cashin/addnew",
            headTableName: DatabaseConstants.cashinHeadTable);

        // Emit final state with messages (whether success or errors)
        emit(state.copyWith(
            isSendingSubmitted: false,
            isSendingSucc: RemoteInvoiceRepoImpl.problems == 0,
            messages: RemoteInvoiceRepoImpl.messages.isNotEmpty
                ? List<String>.from(RemoteInvoiceRepoImpl.messages)
                : [],
            errorMessage: null));
      } catch (e) {
       final result = await InternetAddress.lookup('google.com');
        String errorMsg = "حدث خطأ أثناء إرسال البيانات";
         if (e.toString().contains("401")) {
           errorMsg = "انتهت صلاحية الجلسة. يرجى تسجيل الدخول مرة أخرى";
         } else if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
         errorMsg = "فشل الاتصال بالخادم. يرجى التحقق من الاتصال بالإنترنت";
         } else {
        errorMsg = e.toString();
         }
        emit(state.copyWith(
          isSendingSubmitted: false,
          isSendingSucc: false,
          errorMessage: errorMsg,
        ));
      }
    });
  }
}
