import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Theo dõi trạng thái đăng nhập
  Stream<User?> get authStateChange => _auth.authStateChanges();

  // Đăng nhập
  Future<UserCredential> login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Lấy thông tin User từ Firestore (bao gồm Role)
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  // Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Sửa lại hàm signUp trong AuthRepository
Future<void> signUp(String email, String password) async {
  // 1. Tạo tài khoản trên Auth
  UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
  // 2. Mặc định luôn là 'user' để bảo mật
  UserModel newUser = UserModel(uid: credential.user!.uid, email: email.trim(), role: 'user',);
  await _firestore.collection('users').doc(credential.user!.uid).set(newUser.toMap());
  }
}