// ignore_for_file: file_names
List<ItemsSerialsModel> itemsSerialList = [];

class ItemsSerialsModel {
  String? itemid;
  String? name;
  String? serialNumber;
  ItemsSerialsModel(this.itemid, this.name, this.serialNumber);
  ItemsSerialsModel.fromMap(Map<String, dynamic> res) {
    itemid = res['itemid'];
    name = res['name'];
    serialNumber = res['serialnumber'];
  }
  Map<String, Object?> toMap() {
    return {"itemid": itemid, "name": name, "serialnumber": serialNumber};
  }

//Remember!!!!!

  // Future<void> getSerials() async {
  //   String jsonString;
  //   String t = await _login.tocken();

  //   var headers = {'Authorization': 'Bearer ' + t};

  //   var request = http.Request(
  //       'GET', Uri.parse(MyApp.apiUrl + 'nsbase/GetItemsSerialNo'));

  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     jsonString = await response.stream.bytesToString();
  //     Map<String, dynamic> mydata = jsonDecode(jsonString);
  //     for (int i = 0; i < mydata["data"].length; i++) {
  //       itemsSerialList.add(ItemsSerialsModel(
  //           mydata["data"][i]["id"].toString(),
  //           mydata["data"][i]["name"].toString(),
  //           mydata["data"][i]["serialnumber"].toString()));
  //     }
  //     for (var i = 0; i < itemsSerialList.length; i++) {
  //       dbHelper.insertitemsserials(itemsSerialList[i]);
  //     }
  //   }
  // }
}
