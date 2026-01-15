import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/cart_provider.dart';
import '../../orders/view/checkout_screen.dart';
// CẬP NHẬT: Import Utility định dạng tiền
import '../../../core/utils/currency_utils.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    
    // Tính tổng tiền
    double total = cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng của bạn')),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Giỏ hàng đang trống.\nHãy chọn sản phẩm bạn yêu thích!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(
                            item.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // CẬP NHẬT: Hiển thị đơn giá bằng CurrencyUtils
                              Text(
                                'Đơn giá: ${CurrencyUtils.formatVND(item.product.price)}',
                                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, -1),
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.blue),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, 1),
                                    icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              ref.read(cartProvider.notifier).removeFromCart(item.product.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Đã xóa khỏi giỏ hàng'),
                                  duration: Duration(milliseconds: 800),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Tổng cộng:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          // CẬP NHẬT: Hiển thị tổng tiền bằng CurrencyUtils
                          Text(
                            CurrencyUtils.formatVND(total),
                            style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(items: cartItems),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text(
                            'TIẾN HÀNH THANH TOÁN',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}