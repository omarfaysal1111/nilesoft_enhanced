import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

class SettingsModel implements BaseModel {
  String? mobileUserId;
  String? cashaccId;
  String? coinPrice;
  String? invId;
  String? visaId;
  int? invoiceSerial;
  bool? multiunit;
  int? inStock;
  SettingsModel(
      {this.cashaccId,
      this.coinPrice,
      this.invoiceSerial,
      this.invId,
      this.mobileUserId,
      this.visaId,
      this.inStock,
      this.multiunit});

  SettingsModel.fromMap(Map<String, dynamic> res) {
    mobileUserId = res["mobileUserId"];
    cashaccId = res["cashaccId"];
    coinPrice = res["coinPrice"];
    invId = res["invid"];
    visaId = res["visaId"];
    invoiceSerial = res["invoiceserial"];
    final dynamic stockRaw = res["instock"] ?? res["showsalesinvenbal"];
    if (stockRaw == null) {
      inStock = null;
    } else if (stockRaw is bool) {
      inStock = stockRaw ? 1 : 0;
    } else {
      inStock = int.tryParse(stockRaw.toString());
    }
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
      "instock": inStock,
      "invoiceserial": invoiceSerial,
      "multiunit": multiunit == true ? 1 : 0
    };
  }
}
