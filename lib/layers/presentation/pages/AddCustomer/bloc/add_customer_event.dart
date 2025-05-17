import 'package:nilesoft_erp/layers/domain/models/add_customer.dart';
import 'package:nilesoft_erp/layers/domain/models/city.dart';

abstract class AddCustomerEvent {}

class OnAddCustomerInit extends AddCustomerEvent {}

class OnAreasLoaded extends AddCustomerEvent {
  final List<CityModel> areas;
  final List<CityModel> cities;
  final List<CityModel> govs;

  OnAreasLoaded(
      {required this.areas, required this.cities, required this.govs});
}

class OnAreaSelected extends AddCustomerEvent {
  final CityModel? selectedArea;

  OnAreaSelected({this.selectedArea});
}

class OnGovSelected extends AddCustomerEvent {
  final CityModel? selectedGov;

  OnGovSelected({this.selectedGov});
}

class OnCitySelected extends AddCustomerEvent {
  final CityModel? selectedCity;

  OnCitySelected({this.selectedCity});
}

class OnAddCustomer extends AddCustomerEvent {
  final AddCustomerModel customerModel;

  OnAddCustomer({required this.customerModel});
}
