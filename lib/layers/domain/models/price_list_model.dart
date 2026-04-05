import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

String? _trimOrNull(String? s) {
  if (s == null) return null;
  final t = s.trim();
  return t.isEmpty ? null : t;
}

String? _readPriceListListId(Map<String, dynamic> res) {
  const keys = <String>[
    'listid',
    'ListId',
    'ListID',
    'list_id',
    'pricelistid',
    'PriceListId',
    'PricelistID',
    'PriceListID',
    'price_list_id',
    'plid',
    'PLId',
    'PLID',
    'listno',
    'ListNo',
    'PriceListMasterId',
    'priceListMasterId',
    'masterlistid',
    'MasterListId',
  ];
  for (final k in keys) {
    if (!res.containsKey(k)) continue;
    final v = res[k];
    if (v == null) continue;
    final t = v.toString().trim();
    if (t.isNotEmpty && t != 'null') return t;
  }
  for (final e in res.entries) {
    final ek = e.key.toLowerCase();
    if (ek == 'pricelistid' ||
        ek == 'pricelist_id' ||
        ek == 'listid' ||
        ek == 'list_id' ||
        ek == 'listno') {
      final v = e.value;
      if (v == null) continue;
      final t = v.toString().trim();
      if (t.isNotEmpty && t != 'null') return t;
    }
  }
  return null;
}

String? _readPriceListItemId(Map<String, dynamic> res) {
  final dynamic raw = res['itemid'] ??
      res['ItemId'] ??
      res['item_id'] ??
      res['ItemID'] ??
      res['itemcode'] ??
      res['ItemCode'] ??
      res['productid'] ??
      res['ProductId'];
  return _trimOrNull(raw?.toString());
}

int? _readIntId(dynamic raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  return int.tryParse(raw.toString().trim());
}

class PriceListModel implements BaseModel {
  int? id;
  String? listid;
  String? itemid;
  String? consumerprice;
  double? wholesaleprice;
  String? halfsaleprice;

  PriceListModel({
    this.id,
    this.listid,
    this.itemid,
    this.consumerprice,
    this.wholesaleprice,
    this.halfsaleprice,
  });

  PriceListModel.fromMap(Map<String, dynamic> res) {
    id = _readIntId(res['id']);
    final int? apiRowOrListId = id;
    // API often sends the same `id` on every line (list #); never insert that as SQLite PK.
    listid = _readPriceListListId(res) ??
        (apiRowOrListId != null && apiRowOrListId > 0
            ? apiRowOrListId.toString()
            : null);
    itemid = _readPriceListItemId(res);
    consumerprice = _trimOrNull(res['consumerprice']?.toString()) ??
        _trimOrNull(res['ConsumerPrice']?.toString());
    if (res['wholesaleprice'] != null) {
      wholesaleprice = double.tryParse(res['wholesaleprice'].toString());
    } else if (res['WholesalePrice'] != null) {
      wholesaleprice = double.tryParse(res['WholesalePrice'].toString());
    } else {
      wholesaleprice = null;
    }
    halfsaleprice = _trimOrNull(
        (res['halfwholesaleprice'] ?? res['halfsaleprice'] ?? res['HalfSalePrice'])
            ?.toString());
  }

  /// Omits SQLite `id` so the DB auto-increment primary key is used (API `id` is not unique per row).
  @override
  Map<String, Object?> toMap() {
    return {
      'listid': listid?.trim(),
      'itemid': itemid?.trim(),
      'consumerprice': consumerprice,
      'wholesaleprice': wholesaleprice,
      'halfsaleprice': halfsaleprice,
    };
  }
}
