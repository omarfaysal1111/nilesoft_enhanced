// ignore_for_file: file_names
import 'package:nilesoft_erp/layers/data/models/base_model.dart';

class ItemsModel implements BaseModel {
  String? itemid;
  String? name;
  double? price;
  double? qty;
  String? barcode;
  int? hasSerial;
  ItemsModel(this.itemid, this.name, this.price, this.qty, this.barcode,
      this.hasSerial);
  ItemsModel.fromMap(Map<String, dynamic> res) {
    itemid = res['itemid'];
    name = res['name'];
    price = double.parse(res['price'].toString());
    qty = double.parse(res['qty'].toString());
    hasSerial = res['hasSerial'];
    barcode = res['barcode'];
  }
  @override
  Map<String, Object?> toMap() {
    return {
      "itemid": itemid,
      "name": name,
      "price": price,
      "qty": qty,
      "hasSerial": hasSerial,
      "barcode": barcode
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemsModel &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
