import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Logic Đặt hàng và Trừ kho (Giữ nguyên)
  Future<void> placeOrder(OrderModel order) async {
    return _firestore.runTransaction((transaction) async {
      // Duyệt qua từng sản phẩm để kiểm tra và trừ kho
      for (var item in order.items) {
        DocumentReference productRef = _firestore.collection('products').doc(item['productId']);
        DocumentSnapshot productDoc = await transaction.get(productRef);

        if (!productDoc.exists) throw Exception("Sản phẩm không tồn tại!");
        
        int currentStock = productDoc['stock'];
        int orderQty = item['quantity'];

        if (currentStock < orderQty) {
          throw Exception("Sản phẩm ${item['name']} đã hết hàng!");
        }

        // Trừ kho
        transaction.update(productRef, {'stock': currentStock - orderQty});
      }

      // Tạo document đơn hàng mới
      DocumentReference orderRef = _firestore.collection('orders').doc();
      transaction.set(orderRef, order.toMap());
    });
  }

  // 2. CẬP NHẬT: Lấy danh sách đơn hàng theo phân quyền (Admin vs User)
  Stream<List<Map<String, dynamic>>> getOrders(String? userId, String role) {
    // Khởi tạo query mặc định sắp xếp theo thời gian mới nhất
    Query query = _firestore.collection('orders').orderBy('createdAt', descending: true);

    // PHÂN QUYỀN LOGIC:
    // Nếu là 'user', chỉ lấy các đơn hàng do chính họ đặt (userId khớp)
    // Nếu là 'admin', query giữ nguyên (lấy toàn bộ đơn hàng trong hệ thống)
    if (role == 'user' && userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // Lưu lại ID của document vào data để hiển thị ở UI nếu cần
        data['id'] = doc.id; 
        return data;
      }).toList();
    });
  }
}