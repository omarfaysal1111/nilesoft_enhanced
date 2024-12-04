// ignore_for_file: file_names
import 'package:nilesoft_erp/layers/data/models/base_model.dart';

class CustomersModel implements BaseModel {
  String? id;
  String? name;
  int? type;

  CustomersModel(this.id, this.name, this.type);
  CustomersModel.fromMap(Map<String, dynamic> res) {
    id = res['id'];
    name = res['name'];
    type = res["acctype"];
  }
  Map<String, Object?> toMap() {
    return {"id": id, "name": name, "acctype": type};
  }
}
