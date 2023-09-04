import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_app/model/product_model.dart';
import 'package:todo_app/token_box.dart';

Future<List<Product>?> getAllProducts() async {
  final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/services/app/ProductSync/GetAllproduct');

  final tokenBox = TokenBox();
  final accessToken = await tokenBox.getToken();

  if (accessToken == null) {
    print("Access token not available.");
    return null;
  }

  final headers = <String, String>{
    'Authorization': 'Bearer $accessToken',
    'Abp.TenantId': '10', // Replace with your actual Tenant ID
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      final List<Product> products = jsonResponse.map((json) => Product.fromJson(json)).toList();
      return products;
    } else {
      print('Failed to retrieve data. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Request failed: $e");
  }

  return null;
}
