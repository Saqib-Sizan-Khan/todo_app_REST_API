class Product {
  final int tenantId;
  final String name;
  final String description;
  final bool isAvailable;
  final int id;

  Product({
    required this.tenantId,
    required this.name,
    required this.description,
    required this.isAvailable,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      tenantId: json['tenantId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      isAvailable: json['isAvailable'] as bool,
      id: json['id'] as int,
    );
  }
}
