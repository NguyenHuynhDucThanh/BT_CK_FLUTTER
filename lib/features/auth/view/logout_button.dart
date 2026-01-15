import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/auth_provider.dart';
import '../../landing/view/landing_screen.dart';

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.logout_rounded, color: Colors.red),
      onPressed: () async {
        // Gọi logic đăng xuất từ Repository
        await ref.read(authRepositoryProvider).logout();
        
        // Xóa trạng thái user hiện tại
        ref.read(userProvider.notifier).state = null;
        
        // Điều hướng về trang Landing
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LandingScreen()),
            (route) => false,
          );
        }
      },
    );
  }
}