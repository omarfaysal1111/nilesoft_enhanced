// ignore_for_file: file_names
import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

class CashinModelSend {
  CashinModel? cashinModelHead;

  CashinModelSend({this.cashinModelHead});

  Map toJson() {
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
    this.descr,
  });
  CashinModel.fromMap(Map<String, dynamic> res) {
    id = res['id'];
    docDate = res['docdate'];
    total = res['total'];
    clint = res["client"];
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
      "accid": accId
    };
  }
}
