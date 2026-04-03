import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nilesoft_erp/main.dart';

class CustomerLocationRepoImpl {
  Future<void> updateCustomerLocation({
    required String customerId,
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.post(
      Uri.parse("${MyApp.baseurl}fastcustomers/updatelocation"),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${MyApp.token}'
      },
      body: jsonEncode({
        "id": customerId,
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to update customer location: ${response.statusCode}");
    }
  }
}
