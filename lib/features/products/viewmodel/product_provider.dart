import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/product_repository.dart';
import '../../../core/models/product_model.dart';

final productRepositoryProvider = Provider((ref) => ProductRepository());

// Provider tự động cập nhật danh sách sản phẩm khi Firestore thay đổi
final productsStreamProvider = StreamProvider<List<ProductModel>>((ref) {
  return ref.watch(productRepositoryProvider).getProducts();
});