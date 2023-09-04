import 'package:hive/hive.dart';
import 'package:todo_app/model/product_model.dart';

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0; // Unique identifier for this TypeAdapter

  @override
  Product read(BinaryReader reader) {
    // Implement how to deserialize a Product object here
    // Example:
    final tenantId = reader.read() as int;
    final name = reader.read() as String;
    final description = reader.read() as String;
    final isAvailable = reader.read() as bool;
    final id = reader.read() as int;

    return Product(
      tenantId: tenantId,
      name: name,
      description: description,
      isAvailable: isAvailable,
      id: id,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    // Implement how to serialize a Product object here
    // Example:
    writer.write(obj.tenantId);
    writer.write(obj.name);
    writer.write(obj.description);
    writer.write(obj.isAvailable);
    writer.write(obj.id);
  }
}
