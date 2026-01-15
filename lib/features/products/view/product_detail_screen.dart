import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/product_model.dart';
import '../../cart/viewmodel/cart_provider.dart';
import '../../orders/view/checkout_screen.dart';
import '../../../core/utils/currency_utils.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. PHẦN HÌNH ẢNH SẢN PHẨM VỚI APP BAR TÍCH HỢP
          Stack(
            children: [
              Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: widget.product.imageUrl.isNotEmpty
                      ? Image.network(
                          widget.product.imageUrl,
                          fit: BoxFit.cover,
                          // Xử lý khi lỗi link ảnh hoặc lỗi CORS
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.broken_image_outlined,
                            size: 100,
                            color: Colors.grey,
                          ),
                        )
                      : const Icon(
                          Icons.shopping_bag_outlined,
                          size: 100,
                          color: Colors.blue,
                        ),
                ),
              ),
              // Nút back overlay
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. THÔNG TIN CHI TIẾT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        CurrencyUtils.formatVND(widget.product.price),
                        style: const TextStyle(
                          fontSize: 22, 
                          color: Colors.redAccent, 
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trạng thái: ${widget.product.stock > 0 ? "Còn hàng (${widget.product.stock})" : "Hết hàng"}',
                    style: TextStyle(
                      color: widget.product.stock > 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Mô tả sản phẩm:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Đây là sản phẩm chất lượng cao được cung cấp bởi hệ thống Smart Sales. Sản phẩm đảm bảo nguồn gốc xuất xứ và độ bền vượt trội.',
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  
                  // BỘ CHỌN SỐ LƯỢNG
                  Row(
                    children: [
                      const Text('Chọn số lượng:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => setState(() => quantity > 1 ? quantity-- : null),
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.blue),
                            ),
                            Text(
                              '$quantity',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () => setState(() => quantity < widget.product.stock ? quantity++ : null),
                              icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // 3. THANH ĐIỀU HƯỚNG MUA HÀNG
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Row(
              children: [
                // Nút Thêm vào giỏ
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.product.stock > 0 ? () {
                      ref.read(cartProvider.notifier).addToCart(widget.product, quantity);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã thêm vào giỏ hàng thành công!'), duration: Duration(seconds: 1)),
                      );
                    } : null,
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('GIỎ HÀNG'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Nút Đặt hàng ngay
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.product.stock > 0 ? () {
                      final singleItem = [CartItem(product: widget.product, quantity: quantity)];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(items: singleItem),
                        ),
                      );
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: const Text('MUA NGAY', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}