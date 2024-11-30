// ignore_for_file: file_names
class ItemsModel {
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
    price = res['price'];
    qty = res['qty'];
    hasSerial = res['hasSerial'];
    barcode = res['barcode'];
  }
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
}
