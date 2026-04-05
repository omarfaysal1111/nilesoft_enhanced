// ignore_for_file: file_names
import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

int? _parseListId(dynamic raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  if (raw is double) return raw.round();
  final t = raw.toString().trim();
  if (t.isEmpty) return null;
  final i = int.tryParse(t);
  if (i != null) return i;
  final d = double.tryParse(t);
  return d?.round();
}

class CustomersModel implements BaseModel {
  String? id;
  String? name;
  String? type;
  double? discountRatio;
  int? dislistid;
  int? pricelistid;
  double? latitude;
  double? longitude;

  CustomersModel(this.id, this.name, this.type,
      {this.discountRatio,
      this.dislistid,
      this.pricelistid,
      this.latitude,
      this.longitude});

  CustomersModel.fromMap(Map<String, dynamic> res) {
    id = res['id'].toString();
    name = res['name'];
    type = res["acctype"];
    discountRatio = res["discountratio"] != null
        ? double.tryParse(res["discountratio"].toString())
        : null;
    if (res["discount_ratio"] != null && discountRatio == null) {
      discountRatio = double.tryParse(res["discount_ratio"].toString());
    }
    final dynamic disListRaw = res['dislistid'] ??
        res['DisListId'] ??
        res['dislistid'] ??
        res['DislistID'] ??
        res['discountlistid'];
    dislistid = _parseListId(disListRaw);
    final dynamic priceListRaw = res['pricelistid'] ??
        res['PriceListId'] ??
        res['price_list_id'] ??
        res['PricelistID'] ??
        res['pricelistid'];
    pricelistid = _parseListId(priceListRaw);
    latitude = res['latitude'] != null
        ? double.tryParse(res['latitude'].toString())
        : null;
    longitude = res['longitude'] != null
        ? double.tryParse(res['longitude'].toString())
        : null;
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "name": name,
      "acctype": type,
      "discountratio": discountRatio,
      "dislistid": dislistid,
      "pricelistid": pricelistid,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomersModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
