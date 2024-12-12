import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

class SerialsModel implements BaseModel {
  String? serialNumber;
  String? invId;

  SerialsModel({this.invId, this.serialNumber});
  SerialsModel.fromMap(Map<String, dynamic> res) {
    serialNumber = res["serialNumber"];
    invId = res["invId"];
  }

  @override
  Map<String, Object?> toMap() {
    return {"serialNumber": serialNumber, "invid": invId};
  }
}
