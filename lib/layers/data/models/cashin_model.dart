// ignore_for_file: file_names
import 'package:nilesoft_erp/layers/data/models/base_model.dart';

class CashinModelSend {
  CashinModel? cashinModelHead;
  List<CashInDtl> cashInDtl = [];

  CashinModelSend({this.cashinModelHead, cashInDtl});

  Map toJson() {
    List cashInDtl = this.cashInDtl.map((i) => i.toMap()).toList();
    return {
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
    this.descr,
  });
  CashinModel.fromMap(Map<String, dynamic> res) {
    id = res['id'];
    docDate = res['name'];
    accId = res["accid"];
  }
  @override
  Map<String, Object?> toMap() {
    return {"docDate": docDate, "total": total, "descr": descr, "docno": docNo};
  }
}

class CashInDtl {
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
  Map<String, Object?> toMap() {
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
}
