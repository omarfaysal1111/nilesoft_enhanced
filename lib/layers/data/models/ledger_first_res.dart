class LedgerFirstRes {
  double? openbal = 0;
  double? totalDebit = 0;
  double? totalCridet = 0;
  double? currentBalance = 0;
  double? checks = 0;
  int? noofrows = 0;
  LedgerFirstRes(
      {this.openbal,
      this.checks,
      this.currentBalance,
      this.totalCridet,
      this.totalDebit,
      this.noofrows});
  LedgerFirstRes.fromMap(Map<String, dynamic> res) {
    totalCridet = double.parse(res['credit'].toString());
    totalDebit = double.parse(res['debit'].toString());
    currentBalance = double.parse(res['balance'].toString());
    checks = double.parse(res['undertahsil'].toString());
    openbal = double.parse(res['openbal'].toString());
    noofrows = int.parse(res['noofrows'].toString());
  }
  // Map<String, Object?> toMap() {
  //   //return {"accid": accid, "firstrow": firstrow, "openbal": openbal};
  // }
}
