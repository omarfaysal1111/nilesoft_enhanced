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
  double? maxDis;
  /// "1" consumer, "2" wholesale, "3" half — drives price/discount list column choice.
  String? salesInvoiceGomlaDefault;
  /// When 1, line-item discount fields are read-only in sales invoice add popup.
  int? disableItemDiscount;

  SettingsModel(
      {this.cashaccId,
      this.coinPrice,
      this.invoiceSerial,
      this.invId,
      this.mobileUserId,
      this.visaId,
      this.inStock,
      this.multiunit,
      this.maxDis,
      this.salesInvoiceGomlaDefault,
      this.disableItemDiscount});

  SettingsModel.fromMap(Map<String, dynamic> res) {
    mobileUserId = res["mobileUserId"];
    cashaccId = res["cashaccId"];
    coinPrice = res["coinPrice"];
    invId = res["invid"];
    visaId = res["visaId"];
    maxDis=double.parse(res["usermaaxdis"].toString());
    invoiceSerial = res["invoiceserial"];
    final dynamic stockRaw = res["instock"] ?? res["showsalesinvenbal"];
    if (stockRaw == null) {
      inStock = null;
    } else if (stockRaw is bool) {
      inStock = stockRaw ? 1 : 0;
    } else {
      inStock = int.tryParse(stockRaw.toString());
    }
    multiunit = res["multiunit"] == 1 ||
        res["multiunit"] == true ||
        res["multiunit"] == "true";
    salesInvoiceGomlaDefault =
        res["salesinvoicegomladefault"]?.toString() ??
            res["salesInvoiceGomlaDefault"]?.toString();
    final dynamic disRaw =
        res["disableitemdiscount"] ?? res["disableItemDiscount"];
    if (disRaw == null) {
      disableItemDiscount = null;
    } else if (disRaw is bool) {
      disableItemDiscount = disRaw ? 1 : 0;
    } else {
      disableItemDiscount = int.tryParse(disRaw.toString());
    }
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
      "usermaaxdis":maxDis??0,
      "multiunit": multiunit == true ? 1 : 0,
      "salesinvoicegomladefault": salesInvoiceGomlaDefault,
      "disableitemdiscount": disableItemDiscount,
    };
  }
}
