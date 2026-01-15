import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

// Import các màn hình để điều hướng
import 'features/landing/view/landing_screen.dart';
import 'features/auth/viewmodel/auth_provider.dart';
import 'features/home/view/home_screen.dart';
import 'features/products/view/admin_product_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hệ thống Quản lý Bán hàng',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      // Sử dụng AuthWrapper làm trang gốc để điều hướng theo Role
      home: const MainResponsiveWrapper(
        child: AuthWrapper(),
      ),
    );
  }
}

/// BỘ ĐIỀU HƯỚNG THÔNG MINH (THEO ĐÚNG YÊU CẦU CỦA BẠN)
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theo dõi thông tin User và Role từ Provider
    final user = ref.watch(userProvider);

    // 1. Nếu chưa đăng nhập -> Hiện trang Landing giới thiệu
    if (user == null) {
      return const LandingScreen();
    }

    // 2. Nếu là ADMIN -> Vào thẳng trang Quản lý kho hàng (Không qua trang Home)
    if (user.role == 'admin') {
      return const AdminProductManagementScreen();
    }

    // 3. Nếu là USER -> Vào trang Home lung linh giới thiệu sản phẩm
    return const HomeScreen();
  }
}

/// Bộ khung giới hạn chiều rộng màn hình để giả lập giao diện Mobile trên Web
class MainResponsiveWrapper extends StatelessWidget {
  final Widget child;
  const MainResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}