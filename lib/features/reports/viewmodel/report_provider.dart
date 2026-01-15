import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../orders/viewmodel/order_provider.dart';

// Provider cho selected date
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

// Provider tính toán báo cáo theo ngày đã chọn
final adminStatsProvider = Provider((ref) {
  final ordersAsync = ref.watch(ordersStreamProvider);
  final selectedDate = ref.watch(selectedDateProvider);

  return ordersAsync.whenData((orders) {
    double totalRevenue = 0;
    int totalOrders = orders.length;
    double selectedDateRevenue = 0;
    int selectedDateOrders = 0;
    
    // Lấy mốc thời gian 00:00:00 của ngày đã chọn
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final nextDay = selectedDay.add(const Duration(days: 1));

    for (var order in orders) {
      double amount = (order['totalAmount'] as num).toDouble();
      totalRevenue += amount;
      
      final timestamp = order['createdAt'] as Timestamp;
      final orderDate = timestamp.toDate();

      // Kiểm tra nếu đơn hàng thuộc ngày đã chọn (từ 00:00:00 đến 23:59:59)
      // orderDate >= selectedDay AND orderDate < nextDay
      if (!orderDate.isBefore(selectedDay) && orderDate.isBefore(nextDay)) {
        selectedDateRevenue += amount;
        selectedDateOrders++;
      }
    }

    return {
      'totalRevenue': totalRevenue,
      'selectedDateRevenue': selectedDateRevenue,
      'selectedDateOrders': selectedDateOrders,
      'totalOrders': totalOrders,
      'selectedDate': selectedDate,
    };
  });
});