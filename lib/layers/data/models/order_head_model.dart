// ignore_for_file: file_names

class OrderHeadModel {
  String? clientId;
  String? clientName;
  String? notes;

  OrderHeadModel({this.clientId, this.clientName, this.notes});
  OrderHeadModel.fromMap(Map<String, dynamic> res)
      : clientId = res["clientId"],
        clientName = res["clientName"],
        notes = res["notes"];

  Map<String, Object?> toMap() {
    return {"clientId": clientId, "clientName": clientName, "notes": notes};
  }
}

class OrderDtlModel {
  String? itemId;
  String? itemName;
  double? qty;
  double? price;
  double? tax;
  double? discount;
  OrderDtlModel(
      {this.itemId,
      this.itemName,
      this.discount,
      this.price,
      this.qty,
      this.tax});
  OrderDtlModel.fromMap(Map<String, dynamic> res)
      : itemId = res["itemId"],
        itemName = res["itemName"],
        qty = res["qty"],
        price = res["price"],
        discount = res["discount"],
        tax = res["tax"];
  Map<String, Object?> toMap() {
    return {
      "itemId": itemId,
      "itemName": itemName,
      "qty": qty,
      "price": price,
      "tax": tax,
      "discount": discount
    };
  }
}
