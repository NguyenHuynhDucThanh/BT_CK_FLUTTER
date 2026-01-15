import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/viewmodel/auth_provider.dart';
import '../repository/order_repository.dart';

final orderRepositoryProvider = Provider((ref) => OrderRepository());

final ordersStreamProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final user = ref.watch(userProvider);
  if (user == null) return Stream.value([]);
  
  return ref.watch(orderRepositoryProvider).getOrders(user.uid, user.role);
});