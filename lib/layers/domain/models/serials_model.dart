class SerialsModel {
  String? serialNumber;
  String? invId;
  SerialsModel({this.invId, this.serialNumber});
  SerialsModel.fromMap(Map<String, dynamic> res) {
    serialNumber = res["serialNumber"];
    invId = res["invId"];
  }

  Map<String, Object?> toMap() {
    return {"serialNumber": serialNumber, "invId": invId};
  }
}
