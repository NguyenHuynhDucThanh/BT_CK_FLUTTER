import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/viewmodel/auth_provider.dart';
import '../../cart/viewmodel/cart_provider.dart';
import '../repository/order_repository.dart';
import '../../../core/models/order_model.dart';
import '../../../core/utils/currency_utils.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final List<CartItem> items;
  const CheckoutScreen({super.key, required this.items});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  // Controllers cho địa chỉ và số điện thoại
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // Hàm validation
  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập địa chỉ giao hàng';
    }
    if (value.trim().length < 10) {
      return 'Địa chỉ quá ngắn (tối thiểu 10 ký tự)';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    // Loại bỏ spaces và dashes
    final cleanPhone = value.replaceAll(RegExp(r'[\s-]'), '');
    if (cleanPhone.length < 10 || cleanPhone.length > 11) {
      return 'Số điện thoại không hợp lệ (10-11 số)';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanPhone)) {
      return 'Số điện thoại chỉ chứa chữ số';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    double total = widget.items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận đặt hàng'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Danh sách sản phẩm
                  const Text(
                    'Sản phẩm đã chọn',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      final item = widget.items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          title: Text(
                            item.product.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text(
                            '${CurrencyUtils.formatVND(item.product.price)} x ${item.quantity}',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                          trailing: Text(
                            CurrencyUtils.formatVND(item.product.price * item.quantity),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Thông tin giao hàng
                  const Text(
                    'Thông tin giao hàng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // TextField Địa chỉ
                  TextField(
                    controller: addressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ giao hàng',
                      hintText: 'VD: 123 Đường ABC, Quận 1, TP.HCM',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // TextField Số điện thoại
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      hintText: 'VD: 0901234567',
                      prefixIcon: const Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom section với tổng tiền và button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tổng thanh toán:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      CurrencyUtils.formatVND(total),
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate inputs
                      final addressError = _validateAddress(addressController.text);
                      final phoneError = _validatePhone(phoneController.text);

                      if (addressError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(addressError),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (phoneError != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(phoneError),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (user == null) return;

                      try {
                        // Tạo order với thông tin giao hàng
                        final order = OrderModel(
                          id: '',
                          userId: user.uid,
                          userEmail: user.email,
                          shippingAddress: addressController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          items: widget.items.map((i) => {
                            'productId': i.product.id,
                            'name': i.product.name,
                            'price': i.product.price,
                            'quantity': i.quantity,
                          }).toList(),
                          totalAmount: total,
                          createdAt: DateTime.now(),
                        );

                        // Thực hiện đặt hàng
                        await OrderRepository().placeOrder(order);

                        // Xóa giỏ hàng sau khi đặt hàng thành công
                        ref.read(cartProvider.notifier).clearCart();

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đặt hàng thành công!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Quay về màn hình chính
                          Navigator.popUntil(context, (route) => route.isFirst);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi thanh toán: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'XÁC NHẬN THANH TOÁN',
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