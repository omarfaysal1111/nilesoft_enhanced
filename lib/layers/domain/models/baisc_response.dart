class ResponseModel {
  final int message;
  final int docno;
  final int noofserials;
  final List<dynamic>? myerrorList;
  ResponseModel(
      {required this.message,
      required this.docno,
      required this.noofserials,
      this.myerrorList});

  // Factory constructor to create an instance of the model from JSON
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
        message: json['message'],
        docno: json['docno'],
        noofserials: json['noofserials'],
        myerrorList: json['myerrorlist'] ?? []);
  }

  // Method to convert the model instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'docno': docno,
      'noofserials': noofserials,
    };
  }
}
