import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/product_model.dart';

// Model cho item trong giỏ hàng
class CartItem {
  final ProductModel product;
  int quantity;
  CartItem({required this.product, this.quantity = 1});
}

// Quản lý danh sách giỏ hàng (ViewModel logic)
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  // 1. Thêm sản phẩm vào giỏ
  void addToCart(ProductModel product, int qty) {
    final index = state.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      // Nếu có rồi thì tăng số lượng
      state[index].quantity += qty;
      state = [...state]; // Cập nhật state để UI nhận biết
    } else {
      // Nếu chưa có thì thêm mới
      state = [...state, CartItem(product: product, quantity: qty)];
    }
  }

  // 2. XÓA SẢN PHẨM KHỎI GIỎ (MỚI)
  void removeFromCart(String productId) {
    // Lọc bỏ sản phẩm có ID trùng khớp
    state = state.where((item) => item.product.id != productId).toList();
  }

  // 3. CẬP NHẬT SỐ LƯỢNG TRỰC TIẾP (MỚI)
  // delta là số lượng thay đổi (ví dụ: +1 hoặc -1)
  void updateQuantity(String productId, int delta) {
    state = [
      for (final item in state)
        if (item.product.id == productId)
          CartItem(
            product: item.product, 
            // Clamp để đảm bảo số lượng tối thiểu là 1 và tối đa không quá kho
            quantity: (item.quantity + delta).clamp(1, item.product.stock)
          )
        else
          item,
    ];
  }

  // 4. Xóa sạch giỏ hàng sau khi thanh toán
  void clearCart() => state = [];
}

// Provider để View sử dụng
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});