import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

class SalesModel implements BaseModel {
  SalesHeadModel? salesHeadModel;
  List<SalesDtlModel> salesdtlModel = [];
  SalesModel({this.salesHeadModel, required this.salesdtlModel});
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
      "mobile_uuid": salesHeadModel!.mobile_uuid,
      // "invtime": salesHeadModel!.invTime,
      // "docdate": salesHeadModel!.docdate,
      // "invtype": salesHeadModel!.invType,
      // "cashaccid": salesHeadModel!.cashaccid,
      // "coinprice": salesHeadModel!.coinPrice,
      "invoiceno": salesHeadModel!.invoiceno,
      "total": salesHeadModel!.total,
      "dis1": salesHeadModel!.dis1,
      "disam": salesHeadModel!.disam,
      "disratio": salesHeadModel!.disratio,
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
  // ignore: non_constant_identifier_names
  String? mobile_uuid;
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
  double? disam;
  double? disratio;
  // String? visaId;
  int? sent;

  SalesHeadModel(
      {this.accid,
      this.clientName,
      this.descr,
      this.id,
      this.invType,
      this.sent,
      this.disam,
      this.disratio,
      // this.coinPrice,
//this.docdate,
      this.tax,
      this.docDate,
      this.dis1,
      this.cashaccid,
      this.visaid,
      this.invenid,
      // ignore: non_constant_identifier_names
      this.mobile_uuid,
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
        disam = res["disam"],
        disratio = res["disratio"],
        docDate = res["docdate"],
        invType = res["invtype"],
        sent = res["sent"],
        mobile_uuid = res["mobile_uuid"],
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
      "disam": disam,
      "disratio": disratio,
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
      "mobile_uuid": mobile_uuid,
      "net": net,
      // "visaid": visaId,
      // "sent": sent
    };
  }
}

class SalesDtlModel implements BaseModel {
  SalesHeadModel salesHeadModel = SalesHeadModel();
  String? id;
  int? innerid;

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
    this.innerid,
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
        innerid = int.parse(res['innerid'].toString()),
        disam = res["disam"],
        disratio = res["disratio"],
        tax = res["tax"],
        sent = res["sent"];

  @override
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "itemid": itemId,
      // "itemName": itemName,
      "qty": qty,
      "disam": disam,
      "disratio": disratio,
      "price": price,
      "tax": tax,
    };
  }

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "itemid": itemId,
      "itemName": itemName,
      "qty": qty,
      "disam": disam,
      "disratio": disratio,
      "price": price,
      "tax": tax,
    };
  }

  SalesDtlModel clone() {
    return SalesDtlModel(
      id: id,
      innerid: innerid,
      itemName: itemName,
      price: price,
      disam: disam,
      qty: qty,
      tax: tax,
    );
  }
}
