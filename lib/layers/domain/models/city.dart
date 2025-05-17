import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

class CityModel implements BaseModel {
  String id;
  String name;
  CityModel({required this.id, required this.name});

  CityModel.fromMap(Map<String, dynamic> res)
      : id = res['id'].toString(),
        name = res['name'];

  @override
  Map<String, Object?> toMap() {
    return {"id": id, "name": name};
  }
}
