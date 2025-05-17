class AddCustomerModel {
  static int suc = 0;
  static int myid = 0;
  int? glacctype;
  int? acclevel;
  int? main;
  String? id;
  String? name;
  String? address;
  String? phone1;
  String? phone2;
  String? phone3;
  int? cityid;
  String? governmentid;
  String? areaid;
  String? userid;
  String? username;
  int? branchid;
  AddCustomerModel(
      {this.acclevel,
      this.address,
      this.branchid,
      this.glacctype,
      this.id,
      this.main,
      this.name,
      this.phone1,
      required this.areaid,
      required this.cityid,
      required this.governmentid,
      this.phone2,
      this.phone3,
      this.userid,
      this.username});
  AddCustomerModel.fromMap(Map<String, dynamic> res) {
    id = res['id'];
    name = res['name'];
    acclevel = res["acclevel"];
    address = res["address"];
    branchid = res["branchid"];
    glacctype = res["glacctype"];
    main = res["main"];
    phone1 = res["phone1"];
    governmentid = res["governmentid"];
    cityid = res["cityid"];
    areaid = res["areaid"];
    phone2 = res["phone2"];
    phone3 = res["phone3"];
    userid = res["userid"];
    username = res["username"];
  }
  Map<String, Object?> toMap() {
    return {
      "id": "",
      "name": name,
      "glacctype": 1,
      "acctype": 1,
      "acclevel": 0,
      "main": 0,
      "address": address,
      "phone1": phone1,
      "phone2": "",
      "phone3": "",
      "userid": "",
      "cityid": cityid,
      "areaid": areaid,
      "governmentid": governmentid,
      "username": name,
      "branchid": "0"
    };
  }
}
