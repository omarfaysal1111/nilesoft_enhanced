import 'package:nilesoft_erp/layers/domain/models/city.dart';

abstract class LocalAreaRepo {
  Future<List<CityModel>> getAreas({required String tableName});
  Future<CityModel> getAreaById({required int id, required String tableName});
  Future<void> createArea({required CityModel area, required String tableName});
  Future<void> addAllAreas(
      {required List<CityModel> areas, required String tableName});
  Future<void> editAreas({required CityModel area, required String tableName});
  Future<void> deleteArea({required int id});
  Future<void> deleteAllAreas({required String tableName});
}
