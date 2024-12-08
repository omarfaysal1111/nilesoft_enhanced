import 'package:nilesoft_erp/layers/data/models/base_model.dart';

class SalesModel implements BaseModel {
  SalesHeadModel? salesHeadModel;
  List<SalesDtlModel> salesdtlModel = [];
  SalesModel({this.salesHeadModel, salesdtlModel});
  SalesModel.fromMap(Map<String, dynamic> res) {
    salesHeadModel = res["salesHeadModel"];
  }

  @override
  Map<String, dynamic> toMap() {
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

class SalesHeadModel implements BaseModel {
  String? accid;
  String? clientName;
  String? descr;
  String? invoiceno;
  String? cashaccid;
  String? visaid;
  int? id;
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

  SalesHeadModel(
      {this.accid,
      this.clientName,
      this.descr,
      this.id,
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
  SalesHeadModel.fromMap(Map<String, dynamic> res)
      : accid = res["accid"],
        descr = res["descr"],
        id = res["id"],
        docDate = res["docdate"],
        invType = res["invtype"],
        sent = res["sent"],
        clientName = res["clientName"],
        total = res["total"],
        dis1 = res["dis1"],
        tax = res["tax"],
        net = res["net"],
        invoiceno = res["invoiceno"];

  @override
  Map<String, Object?> toMap() {
    return {
      "accid": accid,
      "clientName": clientName,
      "descr": descr,
      // "invtime": invTime,
      "sent": sent,
      "id": id,
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

class SalesDtlModel implements BaseModel {
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
  SalesDtlModel({
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
  SalesDtlModel.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        itemId = res["itemId"],
        itemName = res["itemName"],
        qty = res["qty"],
        price = res["price"],
        // discount = res["discount"],
        tax = res["tax"],
        sent = res["sent"];

  @override
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "itemId": itemId,
      "itemName": itemName,
      "qty": qty,
      "disam": disam,
      "disratio": disratio,
      "price": price,
      "tax": tax,
    };
  }
}
