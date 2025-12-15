import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

class SettingsModel implements BaseModel {
  String? mobileUserId;
  String? cashaccId;
  String? coinPrice;
  String? invId;
  String? visaId;
  int? invoiceSerial;
  bool? multiunit;
  SettingsModel(
      {this.cashaccId,
      this.coinPrice,
      this.invoiceSerial,
      this.invId,
      this.mobileUserId,
      this.visaId,
      this.multiunit});

  SettingsModel.fromMap(Map<String, dynamic> res) {
    mobileUserId = res["mobileUserId"];
    cashaccId = res["cashaccId"];
    coinPrice = res["coinPrice"];
    invId = res["invid"];
    visaId = res["visaId"];
    invoiceSerial = res["invoiceserial"];
    multiunit = res["multiunit"] == 1 || res["multiunit"] == true || res["multiunit"] == "true";
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "mobileUserId": mobileUserId,
      "cashaccId": cashaccId,
      "coinPrice": coinPrice,
      "invid": invId,
      "visaId": visaId,
      "invoiceserial": invoiceSerial,
      "multiunit": multiunit == true ? 1 : 0
    };
  }
}
