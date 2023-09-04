import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/adapter/token_box.dart';

import '../ui/screens/product_list.dart';

final tokenBox = TokenBox();

void loginUser(String username, String password) async {
  final token = await authenticateUser(username, password);
  if (token != null) {
    tokenBox.saveToken(token);
    Get.to(ProductListPage());
  } else {
    Get.snackbar(
        "Authentication Failed",
        "Invalid User Login",
        colorText: Colors.white,
        backgroundColor: Colors.blue);
  }
}

Future<String?> authenticateUser (String username, String password) async {
  final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/TokenAuth/Authenticate');

  final headers = <String, String> {
    'Abp.TenantId' : '10',
    'Content-Type' : 'application/json',
  };

  final body = jsonEncode({
    'userNameOrEmailAddress' : username,
    'password' : password
  });

  try {
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final accessToken = jsonResponse['result']['accessToken'] as String;
      final tokenBox = TokenBox();
      await tokenBox.saveToken(accessToken);
      //print(accessToken);
      return accessToken;
        }
  } catch (e) {
    print("Authentication Failed: $e");
  }

  return null;
}