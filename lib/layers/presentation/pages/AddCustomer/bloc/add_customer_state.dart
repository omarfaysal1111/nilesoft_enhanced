import 'package:nilesoft_erp/layers/domain/models/city.dart';

class AddCustomerState {}

class AddCustomerInit extends AddCustomerState {}

class AddCustomerFailed extends AddCustomerState {}

class AddCustomerSucc extends AddCustomerState {
  final String msg;
  AddCustomerSucc({required this.msg});
}

class AreasLoaded extends AddCustomerState {
  final List<CityModel> areas;
  final List<CityModel> cities;
  final List<CityModel> govs;
  final CityModel? selectedArea;
  final CityModel? selectedCity;
  final CityModel? selectedGov;

  AreasLoaded({
    required this.areas,
    required this.cities,
    required this.govs,
    this.selectedArea,
    this.selectedCity,
    this.selectedGov,
  });

  AreasLoaded copyWith({
    List<CityModel>? areas,
    List<CityModel>? cities,
    List<CityModel>? govs,
    CityModel? selectedArea,
    CityModel? selectedCity,
    CityModel? selectedGov,
  }) {
    return AreasLoaded(
      areas: areas ?? this.areas,
      cities: cities ?? this.cities,
      govs: govs ?? this.govs,
      selectedArea: selectedArea ?? this.selectedArea,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedGov: selectedGov ?? this.selectedGov,
    );
  }
}
