// ignore_for_file: file_names
import 'package:nilesoft_erp/layers/data/models/base_model.dart';

class CustomersModel implements BaseModel {
  String? id;
  String? name;
  String? type;

  CustomersModel(this.id, this.name, this.type);
  CustomersModel.fromMap(Map<String, dynamic> res) {
    id = res['id'].toString();
    name = res['name'];
    type = res["acctype"];
  }
  @override
  Map<String, Object?> toMap() {
    return {"id": id, "name": name, "acctype": type};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomersModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
