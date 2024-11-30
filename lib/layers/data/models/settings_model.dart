class SettingsModel {
  String? mobileUserId;
  String? cashaccId;
  String? coinPrice;
  String? invId;
  String? visaId;
  int? invoiceSerial;
  SettingsModel(
      {this.cashaccId,
      this.coinPrice,
      this.invoiceSerial,
      this.invId,
      this.mobileUserId,
      this.visaId});

  SettingsModel.fromMap(Map<String, dynamic> res) {
    mobileUserId = res["mobileUserId"];
    cashaccId = res["cashaccId"];
    coinPrice = res["coinPrice"];
    invId = res["invid"];
    visaId = res["visaId"];
    invoiceSerial = res["invoiceserial"];
  }

  Map<String, Object?> toMap() {
    return {
      "mobileUserId": mobileUserId,
      "cashaccId": cashaccId,
      "coinPrice": coinPrice,
      "invid": invId,
      "visaId": visaId,
      "invoiceserial": invoiceSerial
    };
  }
}
