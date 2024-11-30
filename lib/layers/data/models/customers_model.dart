// ignore_for_file: file_names
class CustomersModel {
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
