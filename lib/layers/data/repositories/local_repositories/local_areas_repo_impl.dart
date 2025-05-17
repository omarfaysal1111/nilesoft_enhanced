import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/city.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/area_repo.dart';

final DatabaseHelper _databaseHelper = DatabaseHelper();

class LocalsAreasRepoImpl implements LocalAreaRepo {
  @override
  Future<void> addAllAreas(
      {required List<CityModel> areas, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertListRecords(areas, tableName);
  }

  @override
  Future<void> createArea(
      {required CityModel area, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.insertRecord<CityModel>(area, tableName);
  }

  @override
  Future<void> deleteAllAreas({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.deleteAllRecord(tableName);
  }

  @override
  Future<void> deleteArea({required int id}) => throw UnimplementedError();

  @override
  Future<void> editAreas(
          {required CityModel area, required String tableName}) =>
      throw UnimplementedError();

  @override
  Future<CityModel> getAreaById({required int id, required String tableName}) =>
      throw UnimplementedError();

  @override
  Future<List<CityModel>> getAreas({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    return await _databaseHelper.getAllRecords(tableName, CityModel.fromMap);
  }
}
