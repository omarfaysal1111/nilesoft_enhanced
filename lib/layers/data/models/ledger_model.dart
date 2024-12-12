class LedgerModel {
  double? balance;
  String? docdate;
  String? docno;
  String? docno2;
  String? doctype;
  String? descr;
  double? debit;
  double? cridet;

  LedgerModel(
      {this.balance,
      this.docdate,
      this.descr,
      this.docno,
      this.docno2,
      this.doctype,
      this.cridet,
      this.debit});
  LedgerModel.fromMap(Map<String, dynamic> res) {
    cridet = double.parse(res['credit'].toString());
    debit = double.parse(res['debit'].toString());
    balance = double.parse(res['balance'].toString());
    docdate = res['docdate'];
    descr = res['descr'];
    doctype = res['doctype'];
    docno = res['docno'];
    docno2 = res['docno2'];
  }
  // Map<String, Object?> toMap() {
  //   //return {"accid": accid, "firstrow": firstrow, "openbal": openbal};
  // }
}
