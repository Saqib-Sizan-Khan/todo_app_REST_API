import 'package:flutter/material.dart';
import 'package:todo_app/model/product_model.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final String name;
  final String description;
  final bool isAvailable;
  final VoidCallback onEdit;

  ProductWidget({
    required this.name,
    required this.description,
    required this.isAvailable,
    required this.product,
    required this.onEdit
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(name, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          Text(description, textAlign: TextAlign.center),
          Text(isAvailable ? 'Available' : 'Not Available', style: TextStyle(color: isAvailable ? Colors.green : Colors.red)),
          IconButton(
            icon: Icon(Icons.edit, color: Colors.indigo),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
