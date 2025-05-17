import 'package:nilesoft_erp/layers/domain/models/city.dart';

abstract class AreasRepo {
  Future<List<CityModel>> getCities();
  Future<List<CityModel>> getAreas();
  Future<List<CityModel>> getGovs();
}
