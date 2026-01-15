class ProductModel {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String imageUrl;

  ProductModel({required this.id, required this.name, required this.price, required this.stock, required this.imageUrl});

  // Chuyển sang Map để lưu Firestore
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'price': price,
    'stock': stock,
    'imageUrl': imageUrl,
  };

  factory ProductModel.fromMap(Map<String, dynamic> map, String docId) => ProductModel(
    id: docId,
    name: map['name'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    stock: map['stock'] ?? 0,
    imageUrl: map['imageUrl'] ?? '',
  );
}