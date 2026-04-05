import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

String? _trimOrNullDis(String? s) {
  if (s == null) return null;
  final t = s.trim();
  return t.isEmpty ? null : t;
}

String? _readDiscountListListId(Map<String, dynamic> res) {
  const keys = <String>[
    'listid',
    'ListId',
    'ListID',
    'list_id',
    'dislistid',
    'DisListId',
    'DislistID',
    'DiscountListId',
    'discountlistid',
    'discount_list_id',
    'dlid',
    'DLId',
    'listno',
    'ListNo',
    'DiscountListMasterId',
    'discountListMasterId',
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
    if (ek == 'dislistid' ||
        ek == 'discountlistid' ||
        ek == 'discount_list_id' ||
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

int? _readIntIdDis(dynamic raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  return int.tryParse(raw.toString().trim());
}

double? _readDiscountCatId(Map<String, dynamic> res) {
  final dynamic raw = res['discountcatid'] ??
      res['DiscountCatId'] ??
      res['DiscountCatID'] ??
      res['discount_cat_id'] ??
      res['DisCatId'];
  if (raw == null) return null;
  return double.tryParse(raw.toString().trim());
}

class DiscountListModel implements BaseModel {
  int? id;
  String? listid;
  double? discountcatid;
  String? consumerdisratio;
  double? wholedisratio;
  String? halfdisratio;

  DiscountListModel({
    this.id,
    this.listid,
    this.discountcatid,
    this.consumerdisratio,
    this.wholedisratio,
    this.halfdisratio,
  });

  DiscountListModel.fromMap(Map<String, dynamic> res) {
    id = _readIntIdDis(res['id']);
    final int? apiId = id;
    listid = _readDiscountListListId(res) ??
        (apiId != null && apiId > 0 ? apiId.toString() : null);
    discountcatid = _readDiscountCatId(res);
    consumerdisratio = _trimOrNullDis(res['consumerdisratio']?.toString());
    wholedisratio = res['wholedisratio'] != null
        ? double.tryParse(res['wholedisratio'].toString())
        : null;
    halfdisratio = _trimOrNullDis(
        (res['wholehalfdisratio'] ?? res['halfdisratio'])?.toString());
  }

  @override
  Map<String, Object?> toMap() {
    return {
      'listid': listid?.trim(),
      'discountcatid': discountcatid,
      'consumerdisratio': consumerdisratio,
      'wholedisratio': wholedisratio,
      'halfdisratio': halfdisratio,
    };
  }
}
