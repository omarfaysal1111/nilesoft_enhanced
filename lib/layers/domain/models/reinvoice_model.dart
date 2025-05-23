class RSalesModel {
// ignore_for_file: file_names

  RSalesHeadModel? salesHeadModel;
  List<RSalesDtlModel> salesdtlModel = [];
  RSalesModel({this.salesHeadModel, salesdtlModel});
  RSalesModel.fromMap(Map<String, dynamic> res) {
    salesHeadModel = res["RsalesHeadModel"];
  }
  Map toJson() {
    List salesdtlModel = this.salesdtlModel.map((i) => i.toMap()).toList();

    return {
      "accid": salesHeadModel!.accid,
      //    "clientName": salesHeadModel!.clientName,
      "descr": salesHeadModel!.descr,
      "guidetype": "1",
      // "invtime": salesHeadModel!.invTime,
      // "docdate": salesHeadModel!.docdate,
      // "invtype": salesHeadModel!.invType,
      // "cashaccid": salesHeadModel!.cashaccid,
      // "coinprice": salesHeadModel!.coinPrice,
      "invoiceno": salesHeadModel!.invoiceno,
      "total": salesHeadModel!.total,
      "dis1": salesHeadModel!.dis1,
      "visaid": salesHeadModel!.visaid,
      "invenid": salesHeadModel!.invenid,
      "cashaccid": salesHeadModel!.cashaccid,
      "tax": salesHeadModel!.tax,
      "invtype": salesHeadModel!.invType,
      "docdate": salesHeadModel!.docDate,
      "net": salesHeadModel!.net,
      // "sent": salesHeadModel!.sent,
      // "visaid": salesHeadModel!.visaId,
      "dtl": salesdtlModel
    };
  }
}

class RSalesHeadModel {
  String? accid;
  String? clientName;
  String? descr;
  String? invoiceno;
  String? cashaccid;
  String? visaid;
  String? invenid;
  // String? invTime;
  // String? docdate;
  // String? invType;
  // String? cashaccid;
  // int? coinPrice = 1;
  double? total;
  double? dis1;
  String? docDate;
  double? tax;
  double? net;
  String? invType;
  // String? visaId;
  int? sent;

  RSalesHeadModel(
      {this.accid,
      this.clientName,
      this.descr,
      this.invType,
      this.sent,
      // this.coinPrice,
//this.docdate,
      this.tax,
      this.docDate,
      this.dis1,
      this.cashaccid,
      this.visaid,
      this.invenid,
      this.net,
      this.total,
      this.invoiceno
      // this.visaId,
      // this.cashaccid
      });
  RSalesHeadModel.fromMap(Map<String, dynamic> res)
      : accid = res["accid"],
        descr = res["descr"],
        docDate = res["docdate"],
        invType = res["invtype"],
        sent = res["sent"];

  Map<String, Object?> toMap() {
    return {
      "accid": accid,
      "clientName": clientName,
      "descr": descr,
      // "invtime": invTime,
      "sent": sent,
      //  "docdate": docdate,
      // "invtype": invType,
      // "cashaccid": cashaccid,
      // "coinprice": coinPrice,
      "total": total,
      "docdate": docDate,
      "dis1": dis1,
      "invtype": invType,
      "invoiceno": invoiceno,
      "tax": tax,
      "net": net,
      // "visaid": visaId,
      // "sent": sent
    };
  }
}

class RSalesDtlModel {
  String? id;
  String? itemId;
  String? itemName;
  double? qty;
  double? price;
  double? tax;
  double? disratio;
  double? disam;
  // double? discount;
  int? sent;
  RSalesDtlModel({
    this.id,
    this.itemId,
    this.itemName,
    // this.discount,
    this.price,
    this.disam,
    this.disratio,
    this.qty,
    this.tax,
  });
  RSalesDtlModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        itemId = res["itemId"],
        itemName = res["itemName"],
        qty = res["qty"],
        price = res["price"],
        // discount = res["discount"],
        tax = res["tax"],
        sent = res["sent"];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "itemId": itemId,
      // "itemName": itemName,
      "qty": qty,
      "disam": disam,
      "disratio": disratio,
      "price": price,
      "tax": tax,
    };
  }
}
