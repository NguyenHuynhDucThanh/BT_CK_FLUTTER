class OrderModel {
  final String id;
  final String userId;
  final String userEmail;
  final String shippingAddress; // Địa chỉ giao hàng
  final String phoneNumber;     // Số điện thoại
  final List<Map<String, dynamic>> items;
  final double totalAmount;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.shippingAddress,
    required this.phoneNumber,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userEmail': userEmail,
    'shippingAddress': shippingAddress,
    'phoneNumber': phoneNumber,
    'items': items,
    'totalAmount': totalAmount,
    'createdAt': createdAt,
  };
}