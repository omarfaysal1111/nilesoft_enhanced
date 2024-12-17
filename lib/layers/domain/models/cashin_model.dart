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

  int? branchid;
  int? shiftid;

  CashinModel({
    this.id,
    this.docDate,
    this.docNo,
    this.total,
    this.accId,
    this.clint,
    this.mobileuuid,
    this.descr,
  });
  CashinModel.fromMap(Map<String, dynamic> res) {
    id = res['id'];
    docDate = res['docdate'];
    total = res['total'];
    clint = res["client"];
    mobileuuid = res["mobile_uuid"];
    docNo = res["docno"];
    descr = res["descr"];
    accId = res["accid"];
  }
  @override
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "docdate": docDate,
      "total": total,
      "descr": descr,
      "docno": docNo,
      "client": clint,
      "accid": accId,
      "mobile_uuid": mobileuuid
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
      this.serial,
      this.shiftid});
  CashInDtl.fromMap(Map<String, dynamic> res) {
    accountid = res["accountid"];
    amount = res["amount"];
    descr = res["descr"];
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
    };
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }
}
