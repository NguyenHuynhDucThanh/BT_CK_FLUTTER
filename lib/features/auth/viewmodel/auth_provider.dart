import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repository/auth_repository.dart';
import '../../../core/models/user_model.dart';

// 1. Provider cho Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// 2. Provider quản lý thông tin User hiện tại
final userProvider = StateProvider<UserModel?>((ref) => null);

// 3. Provider kiểm tra trạng thái login
final authStateProvider = StreamProvider((ref) {
  return ref.watch(authRepositoryProvider).authStateChange;
});