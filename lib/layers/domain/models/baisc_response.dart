class ResponseModel {
  final int message;
  final int docno;
  final int noofserials;

  ResponseModel({
    required this.message,
    required this.docno,
    required this.noofserials,
  });

  // Factory constructor to create an instance of the model from JSON
  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      message: json['message'],
      docno: json['docno'],
      noofserials: json['noofserials'],
    );
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
