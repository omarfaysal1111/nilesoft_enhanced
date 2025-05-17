import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/models/city.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_areas_repo.dart';

class AreasRepoModelImpl extends AreasRepo {
  @override
  Future<List<CityModel>> getAreas() async {
    return await MainFun.getReq(CityModel.fromMap, "nsbase/getareas");
  }

  @override
  Future<List<CityModel>> getCities() async {
    return await MainFun.getReq(CityModel.fromMap, "nsbase/getcity");
  }

  @override
  Future<List<CityModel>> getGovs() async {
    return await MainFun.getReq(CityModel.fromMap, "nsbase/getgov");
  }
}
