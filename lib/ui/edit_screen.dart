import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/token_box.dart';
import '../model/product_model.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late bool isAvailable;

  @override
  void initState() {
    super.initState();
    // Initialize controllers and set initial values based on the product
    nameController = TextEditingController(text: widget.product.name);
    descriptionController = TextEditingController(text: widget.product.description);
    isAvailable = widget.product.isAvailable;
  }

  @override
  void dispose() {
    // Dispose of controllers
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final url = Uri.parse('https://stg-zero.propertyproplus.com.au/api/services/app/ProductSync/CreateOrEdit');

    final tokenBox = TokenBox();
    final accessToken = await tokenBox.getToken();

    if (accessToken == null) {
      print("Access token not available.");
      return;
    }

    final headers = <String, String>{
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Abp.TenantId': '10', // Replace with your actual Tenant ID
    };

    final requestBody = {
      "tenantId": widget.product.tenantId,
      "name": nameController.text,
      "description": descriptionController.text,
      "isAvailable": isAvailable,
      "id": widget.product.id,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Product data successfully edited or created
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        print('Failed to edit or create product. Status code: ${response.statusCode}');
        // Handle error, show a message to the user, etc.
      }
    } catch (e) {
      print("Request failed: $e");
      // Handle error, show a message to the user, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveChanges();
              }
            },
          ),
        ],
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
    );
  }
}
