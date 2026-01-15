import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lấy danh sách sản phẩm (Stream để cập nhật thời gian thực)
  Stream<List<ProductModel>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // Admin: Thêm sản phẩm
  Future<void> addProduct(ProductModel product) async {
    await _firestore.collection('products').add(product.toMap());
  }

  // Admin: Sửa sản phẩm
Future<void> updateProduct(ProductModel product) async {
  await _firestore.collection('products').doc(product.id).update(product.toMap());
}

  // Admin: Xóa sản phẩm
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }
}