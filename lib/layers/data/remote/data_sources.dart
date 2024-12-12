import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nilesoft_erp/main.dart';

class MainFun {
  static Future<void> navTo(BuildContext context, Widget target) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => target,
    ));
  }

  static Future<T> postReqG<T>(T Function(Map<String, dynamic>) fromJson,
      String path, Map<String, dynamic> postData) async {
    try {
      final response = await http.post(
        Uri.parse("${MyApp.baseurl}$path"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        String jsonString = response.body;
        Map<String, dynamic> responseBody =
            jsonDecode(jsonString); // Decode as Map

        // Map the response to the specified model using fromJson
        T result = fromJson(responseBody);
        return result;
      } else {
        throw Exception("Error posting data: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<T>> getReq<T>(
      T Function(Map<String, dynamic>) fromJson, String path) async {
    try {
      final response = await http.get(
        Uri.parse("${MyApp.baseurl}$path"),
        //tocken
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${MyApp.tocken}'
        },
      );

      if (response.statusCode == 200) {
        String jsonString = response.body;

        // Decode JSON response as Map
        Map<String, dynamic> jsonResponse = jsonDecode(jsonString);

        // Check if the data field is a list
        if (jsonResponse['data'] is List) {
          List<dynamic> dataList = jsonResponse['data'];

          // Map each item in the data list to the specified model using fromJson
          return dataList
              .map((data) => fromJson(data as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception("Data is not a list");
        }
      } else {
        throw Exception("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<T> getReqMap<T>(
      T Function(Map<String, dynamic>) fromJson, String path) async {
    try {
      final response = await http.get(
        Uri.parse("${MyApp.baseurl}$path"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${MyApp.tocken}'
        },
      );

      if (response.statusCode == 200) {
        String jsonString = response.body;

        // Decode JSON response as Map
        Map<String, dynamic> jsonResponse = jsonDecode(jsonString);

        // Check if the data field is a Map

        if (jsonResponse['data'] is Map<String, dynamic>) {
          Map<String, dynamic> dataMap = jsonResponse['data'];

          // Parse the map using the fromJson function
          return fromJson(dataMap);
        } else {
          return fromJson(jsonResponse);
        }
      } else {
        throw Exception("Error fetching data: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<T> postReq<T>(T Function(Map<String, dynamic>) fromJson,
      String path, Map<String, dynamic> postData) async {
    try {
      final response = await http.post(
        Uri.parse("${MyApp.baseurl}$path"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${MyApp.tocken}'
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        String jsonString = response.body;
        Map<String, dynamic> responseBody =
            jsonDecode(jsonString); // Decode as Map

        // Map the response to the specified model using fromJson
        T result = fromJson(responseBody);
        return result;
      } else {
        throw Exception("Error posting data: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<T>> postReqFList<T>(
    T Function(Map<String, dynamic>)
        fromJson, // Function to parse a single object
    String path,
    Map<String, dynamic> postData,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("${MyApp.baseurl}$path"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${MyApp.tocken}',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        String jsonString = response.body;
        List<dynamic> dataList =
            jsonDecode(jsonString)["data"]; // Parse directly into a List

        // Map each item in the list to the model using the fromJson function
        List<T> result = dataList
            .map((item) => fromJson(item as Map<String, dynamic>))
            .toList();
        return result;
      } else {
        throw Exception("Error posting data: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> postReqList<T>(T Function(Map<String, dynamic>) fromJson,
      String path, List postData) async {
    try {
      final response = await http.post(
        Uri.parse("${MyApp.baseurl}$path"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${MyApp.tocken}'
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        //  String jsonString = response.body;
        //    List responseBody = jsonDecode(jsonString); // Decode as Map

        // Map the response to the specified model using fromJson
        return 200;
      } else {
        throw Exception("Error posting data: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
