import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../viewmodel/product_provider.dart';
import '../../../core/models/product_model.dart';
import '../../../core/utils/currency_utils.dart';
import '../../orders/view/order_history_screen.dart';
import '../../reports/view/report_screen.dart';
import '../../auth/view/logout_button.dart';

class AdminProductManagementScreen extends ConsumerStatefulWidget {
  const AdminProductManagementScreen({super.key});

  @override
  ConsumerState<AdminProductManagementScreen> createState() => _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState extends ConsumerState<AdminProductManagementScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsStreamProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.home_rounded, color: Colors.white),
              tooltip: 'Trang chủ',
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo.shade700,
                      Colors.indigo.shade500,
                      Colors.blue.shade400,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.inventory_2_rounded, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quản lý kho hàng',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Thêm, sửa, xóa sản phẩm',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
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
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bar_chart_rounded, color: Colors.white),
                tooltip: 'Báo cáo',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportScreen()),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.history_rounded, color: Colors.white),
                tooltip: 'Lịch sử đơn hàng',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderHistoryScreen()),
                ),
              ),
              const LogoutButton(),
            ],
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                onChanged: (value) => setState(() => searchQuery = value.toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm sản phẩm...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
            ),
          ),

          // Products List
          productsAsync.when(
            data: (products) {
              // Filter products based on search
              final filteredProducts = products.where((p) {
                return searchQuery.isEmpty || p.name.toLowerCase().contains(searchQuery);
              }).toList();

              if (filteredProducts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Chưa có sản phẩm nào',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = filteredProducts[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: product.imageUrl.isNotEmpty
                                  ? Image.network(
                                      product.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.broken_image, color: Colors.grey),
                                    )
                                  : const Icon(Icons.inventory_2_outlined, color: Colors.blue),
                            ),
                          ),
                          title: Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 6),
                              Text(
                                CurrencyUtils.formatVND(product.price),
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.inventory,
                                    size: 14,
                                    color: product.stock < 10 ? Colors.orange : Colors.green,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Kho: ${product.stock}',
                                    style: TextStyle(
                                      color: product.stock < 10 ? Colors.orange : Colors.green,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue.shade600),
                                onPressed: () => _showEditProductDialog(context, product),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red.shade600),
                                onPressed: () => _showDeleteConfirmation(context, product),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: filteredProducts.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(
                child: Text('Lỗi: $error', style: const TextStyle(color: Colors.red)),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(context),
        backgroundColor: Colors.indigo.shade600,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Thêm sản phẩm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(productRepositoryProvider).deleteProduct(product.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa sản phẩm')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.add_circle, color: Colors.blue),
              SizedBox(width: 12),
              Text('Thêm sản phẩm mới'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Link ảnh sản phẩm (URL)',
                    prefixIcon: Icon(Icons.link),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: imageController.text.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageController.text,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, color: Colors.red, size: 40),
                          ),
                        )
                      : const Center(
                          child: Text('Xem trước ảnh', style: TextStyle(color: Colors.grey)),
                        ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Giá bán (VND)',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThousandsSeparatorInputFormatter(),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Số lượng tồn kho',
                    prefixIcon: Icon(Icons.inventory),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  final newProduct = ProductModel(
                    id: '',
                    name: nameController.text,
                    price: CurrencyUtils.parseVND(priceController.text),
                    stock: int.tryParse(stockController.text) ?? 0,
                    imageUrl: imageController.text.trim(),
                  );
                  ref.read(productRepositoryProvider).addProduct(newProduct);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã thêm sản phẩm mới')),
                  );
                }
              },
              child: const Text('Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, ProductModel product) {
    final nameController = TextEditingController(text: product.name);
    final priceController = TextEditingController(
      text: NumberFormat.decimalPattern('vi').format(product.price),
    );
    final stockController = TextEditingController(text: product.stock.toString());
    final imageController = TextEditingController(text: product.imageUrl);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 12),
              Text('Cập nhật sản phẩm'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Link ảnh sản phẩm (URL)',
                    prefixIcon: Icon(Icons.link),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: imageController.text.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageController.text,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, color: Colors.red, size: 40),
                          ),
                        )
                      : const Icon(Icons.image, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    prefixIcon: Icon(Icons.shopping_bag),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Giá bán (VND)',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    ThousandsSeparatorInputFormatter(),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(
                    labelText: 'Số lượng tồn kho',
                    prefixIcon: Icon(Icons.inventory),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  final updatedProduct = ProductModel(
                    id: product.id,
                    name: nameController.text,
                    price: CurrencyUtils.parseVND(priceController.text),
                    stock: int.tryParse(stockController.text) ?? 0,
                    imageUrl: imageController.text.trim(),
                  );
                  await ref.read(productRepositoryProvider).updateProduct(updatedProduct);
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã cập nhật sản phẩm')),
                    );
                  }
                }
              },
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
