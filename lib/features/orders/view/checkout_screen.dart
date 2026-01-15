import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/viewmodel/auth_provider.dart';
import '../../cart/viewmodel/cart_provider.dart';
import '../repository/order_repository.dart';
import '../../../core/models/order_model.dart';
import '../../../core/utils/currency_utils.dart';

class CheckoutScreen extends ConsumerWidget {
  final List<CartItem> items; // Danh sách sản phẩm được truyền vào
  const CheckoutScreen({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy thông tin user hiện tại (bao gồm email và uid)
    final user = ref.read(userProvider);
    
    // Tính tổng tiền đơn hàng
    double total = items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

    return Scaffold(
      appBar: AppBar(title: const Text('Xác nhận đặt hàng')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(
                    item.product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${CurrencyUtils.formatVND(item.product.price)} x ${item.quantity}'),
                  trailing: Text(
                    CurrencyUtils.formatVND(item.product.price * item.quantity),
                    style: const TextStyle(fontWeight: FontWeight.w500),
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
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tổng thanh toán:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      CurrencyUtils.formatVND(total),
                      style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (user == null) return; // Bảo vệ nếu user chưa kịp load

                      try {
                        // CẬP NHẬT: Thêm userEmail vào OrderModel để Admin dễ theo dõi
                        final order = OrderModel(
                          id: '',
                          userId: user.uid,
                          userEmail: user.email, // <--- LƯU EMAIL KHÁCH HÀNG VÀO ĐÂY
                          items: items.map((i) => {
                            'productId': i.product.id,
                            'name': i.product.name,
                            'price': i.product.price,
                            'quantity': i.quantity,
                          }).toList(),
                          totalAmount: total,
                          createdAt: DateTime.now(),
                        );

                        // Thực hiện đặt hàng và trừ kho
                        await OrderRepository().placeOrder(order);
                        
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đặt hàng thành công!')),
                          );
                          // Quay về màn hình chính sau khi thanh toán xong
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi thanh toán: ${e.toString()}')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, 
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'XÁC NHẬN THANH TOÁN', 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}