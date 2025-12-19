// ignore_for_file: file_names
import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

class CashinModelSend {
  CashinModel? cashinModelHead;
  List<CashInDtl>? cashInDtl;
  CashinModelSend({this.cashinModelHead, this.cashInDtl});

  Map<String, Object?> toJson() {
    return {
      "id": cashinModelHead!.id,
      "docdate": cashinModelHead!.docDate,
      "accid": cashinModelHead!.accId,
      "descr": cashinModelHead!.descr,
      "docno": cashinModelHead!.docNo,
      "userid": "0",
      "username": "",
      "total": cashinModelHead!.total,
      "disc": 0,
      "net1": cashinModelHead!.net1,
      "branchid": 0,
      "shiftid": 0,
      "mobile_uuid": cashinModelHead!.mobileuuid,
      "longitude": cashinModelHead!.longitude,
      "latitude": cashinModelHead!.latitude,
      "dtl": cashInDtl
    };
  }
}

class CashinModel implements BaseModel {
  int? id;
  String? docDate;
  String? accId;
  String? descr;
  String? docNo;
  String? clint;
  String? mobileuuid;
  String? userid;
  String? username;
  double? total;
  double? disc;
  double? net1;
  int? sent;
  int? branchid;
  int? shiftid;
  double? longitude;
  double? latitude;

  CashinModel({
    this.id,
    this.docDate,
    this.docNo,
    this.total,
    this.accId,
    this.sent,
    this.clint,
    this.mobileuuid,
    this.descr,
    this.longitude,
    this.latitude,
  });
  CashinModel.fromMap(Map<String, dynamic> res) {
    id = res['id'];
    docDate = res['docdate'];
    total = res['total'];
    clint = res["client"];
    sent = res["sent"];
    mobileuuid = res["mobile_uuid"];
    docNo = res["docno"];
    descr = res["descr"];
    accId = res["accid"];
    longitude = res["longitude"] != null ? double.tryParse(res["longitude"].toString()) : null;
    latitude = res["latitude"] != null ? double.tryParse(res["latitude"].toString()) : null;
  }
  @override
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "docdate": docDate,
      "total": total,
      "sent": sent,
      "descr": descr,
      "docno": docNo,
      "client": clint,
      "accid": accId,
      "mobile_uuid": mobileuuid,
      "longitude": longitude,
      "latitude": latitude
    };
  }
}

class CashInDtl extends BaseModel {
  String? id;
  String? docno;
  int? serial;
  String? accountid;
  String? salesmanid;
  String? descr;
  double? amount;
  double? discount;
  int? sent;
  int? branchid;
  int? shiftid;
  CashInDtl(
      {this.accountid,
      this.amount,
      this.branchid,
      this.descr,
      this.discount,
      this.docno,
      this.id,
      this.salesmanid,
      this.sent,
      this.serial,
      this.shiftid});
  CashInDtl.fromMap(Map<String, dynamic> res) {
    accountid = res["accountid"];
    amount = res["amount"];
    descr = res["descr"];
    branchid = 0;
    shiftid = 0;
    discount = 0;
    docno = '';
    salesmanid = "";
    serial = 0;
    sent = 0;
  }
  Map<String, Object?> toJson() {
    return {
      "accountid": accountid,
      "descr": descr,
      "amount": amount,
      "discount": discount,
      "branchid": 0,
      "shiftid": 0,
      "docno": '',
      "salesmanid": "",
      "serial": 0
      /* 
      
       id INTEGER PRIMARY KEY AUTOINCREMENT, 
              accountid TEXT ALLOW NULL,
              amount REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              descr TEXT ALLOW NULL,
              shiftid INTEGER ALLOW NULL,
              branchid INTEGER ALLOW NULL,
              docno  TEXT ALLOW NULL,
              salesmanid TEXT ALLOW NULL,
              serial REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
      */
    };
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "accountid": accountid,
      "descr": descr,
      "amount": amount,
      "discount": discount,
      "branchid": 0,
      "shiftid": 0,
      "docno": '',
      "salesmanid": "",
      "serial": 0
      /* 
      
       id INTEGER PRIMARY KEY AUTOINCREMENT, 
              accountid TEXT ALLOW NULL,
              amount REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              descr TEXT ALLOW NULL,
              shiftid INTEGER ALLOW NULL,
              branchid INTEGER ALLOW NULL,
              docno  TEXT ALLOW NULL,
              salesmanid TEXT ALLOW NULL,
              serial REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
      */
    };
  }
}
