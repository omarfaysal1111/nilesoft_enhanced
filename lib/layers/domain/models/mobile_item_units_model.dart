// ignore_for_file: file_names
import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

class MobileItemUnitsModel implements BaseModel {
  String? itemid;
  String? unitid;
  String? unitname;
  double? factor;

  MobileItemUnitsModel({
    this.itemid,
    this.unitid,
    this.unitname,
    this.factor,
  });

  MobileItemUnitsModel.fromMap(Map<String, dynamic> res) {
    itemid = res['itemid']?.toString();
    unitid = res['unitid']?.toString();
    unitname = res['unitname'];
    factor = res['factor'] != null ? double.tryParse(res['factor'].toString()) : null;
  }

  @override
  Map<String, Object?> toMap() {
    return {
      "itemid": itemid,
      "unitid": unitid,
      "unitname": unitname,
      "factor": factor,
    };
  }
}


