import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo_app/token_box.dart';
import 'package:todo_app/ui/edit_screen.dart';
import '../model/product_model.dart';
import 'create_screen.dart';
import 'product_widget.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/services/app/ProductSync/GetAllproduct');

    final tokenBox = TokenBox();
    final accessToken = await tokenBox.getToken();

    if (accessToken == null) {
      print("Access token not available.");
      return;
    }

    final headers = <String, String>{
      'Authorization': 'Bearer $accessToken',
      'Abp.TenantId': '10', // Replace with your actual Tenant ID
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        final List<Product> fetchedProducts = jsonResponse.map((json) => Product.fromJson(json)).toList();
        print(jsonResponse);
        setState(() {
          products = fetchedProducts;
        });
      } else {
        print('Failed to retrieve data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Request failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5
        ),
        itemCount: products.length,
        padding: EdgeInsets.all(10),
        itemBuilder: (BuildContext context, int index) {
          final product = products[index];
          return ProductWidget(
            product: product,
            name: product.name,
            description: product.description,
            isAvailable: product.isAvailable,
            onEdit: () {
              Get.to(EditProductScreen(product: product));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        onPressed: () {
          // Navigate to the screen for creating a new product
          Get.to(CreateProductScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}