import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/local_areas_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/remote_repositories/add_customer_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/models/baisc_response.dart';
import 'package:nilesoft_erp/layers/domain/models/city.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_state.dart';

class AddCustomerBloc extends Bloc<AddCustomerEvent, AddCustomerState> {
  AddCustomerBloc() : super(AddCustomerInit()) {
    on<OnAddCustomerInit>(_onAddCustomerInit);
    on<OnAreaSelected>(_onAreaSelected);
    on<OnCitySelected>(_onCitySelected);
    on<OnGovSelected>(_onGovSelected);
    on<OnAddCustomer>(_onAddCustomer);
  }

  Future<void> _onAddCustomerInit(
      OnAddCustomerInit event, Emitter<AddCustomerState> emit) async {
    LocalsAreasRepoImpl localsAreasRepoImpl = LocalsAreasRepoImpl();
    List<CityModel> areas =
        await localsAreasRepoImpl.getAreas(tableName: "areas");
    List<CityModel> cities =
        await localsAreasRepoImpl.getAreas(tableName: "cities");
    List<CityModel> govs =
        await localsAreasRepoImpl.getAreas(tableName: "govs");
    emit(AreasLoaded(areas: areas, cities: cities, govs: govs));
  }

  Future<void> _onAreaSelected(
      OnAreaSelected event, Emitter<AddCustomerState> emit) async {
    if (state is AreasLoaded) {
      final currentState = state as AreasLoaded;
      emit(currentState.copyWith(selectedArea: event.selectedArea));
    }
  }

  Future<void> _onCitySelected(
      OnCitySelected event, Emitter<AddCustomerState> emit) async {
    if (state is AreasLoaded) {
      final currentState = state as AreasLoaded;
      emit(currentState.copyWith(selectedCity: event.selectedCity));
    }
  }

  Future<void> _onGovSelected(
      OnGovSelected event, Emitter<AddCustomerState> emit) async {
    if (state is AreasLoaded) {
      final currentState = state as AreasLoaded;
      emit(currentState.copyWith(selectedGov: event.selectedGov));
    }
  }

  Future<void> _onAddCustomer(
      OnAddCustomer event, Emitter<AddCustomerState> emit) async {
    try {
      AddCustomerRepoImpl addCustomerRepoImpl = AddCustomerRepoImpl();
      ResponseModel res =
          await addCustomerRepoImpl.addCustomer(customer: event.customerModel);
      if (kDebugMode) {
        print(res);
      }
      emit(AddCustomerSucc(msg: res.message.toString()));
    } catch (e) {
      //  emit(AddCustomerError(message: "Failed to add customer: $e"));
    }
  }
}
