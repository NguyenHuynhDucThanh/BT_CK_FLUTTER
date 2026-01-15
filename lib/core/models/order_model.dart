class OrderModel {
  final String id;
  final String userId;
  final String userEmail; // THÊM DÒNG NÀY
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userEmail, // THÊM DÒNG NÀY
    required this.items,
    required this.totalAmount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userEmail': userEmail, // THÊM DÒNG NÀY
    'items': items,
    'totalAmount': totalAmount,
    'createdAt': createdAt,
  };
}