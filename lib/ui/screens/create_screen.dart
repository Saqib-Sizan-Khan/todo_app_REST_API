import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/token_box.dart';
import '../../model/product_model.dart';

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late bool isAvailable;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    isAvailable = true; // Default to true for new products
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _saveProduct() async {
    // Validate form data
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/services/app/ProductSync/CreateOrEdit');

    final tokenBox = TokenBox();
    final accessToken = await tokenBox.getToken();

    if (accessToken == null) {
      print("Access token not available.");
      return false;
    }

    final headers = <String, String>{
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Abp.TenantId': '10', // Replace with your actual Tenant ID
    };

    final requestBody = {
      "tenantId": 10, // Replace with your actual Tenant ID
      "name": nameController.text,
      "description": descriptionController.text,
      "isAvailable": isAvailable,
      "id": 33, // 0 indicates a new product
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Product data successfully created
        Navigator.pop(context, true); // Return true to indicate success
        return true;
      } else {
        return false;
        // Handle error, show a message to the user, etc.
      }
    } catch (e) {
      print("Request failed: $e");
      return false;
      // Handle error, show a message to the user, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Available'),
                value: isAvailable,
                onChanged: (newValue) {
                  setState(() {
                    isAvailable = newValue;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveProduct,
        child: Icon(Icons.save),
      ),
    );
  }
}
