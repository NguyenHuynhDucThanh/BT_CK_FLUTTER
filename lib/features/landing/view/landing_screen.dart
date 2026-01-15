import 'package:flutter/material.dart';
import '../../auth/view/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. Header với logo và tên shop
          SliverAppBar(
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🏪 TẠP HÓA MINI',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 1.2,
                      shadows: [Shadow(blurRadius: 8, color: Colors.black45)],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Mua sắm tiện lợi - Giá cả hợp lý',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                      shadows: [Shadow(blurRadius: 5, color: Colors.black45)],
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.shade700,
                      Colors.green.shade500,
                      Colors.lightGreen.shade400,
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.store_rounded,
                          size: 60,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Giới thiệu về shop
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.green.shade700, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Về chúng tôi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tạp Hóa Mini là cửa hàng tạp hóa truyền thống kết hợp công nghệ hiện đại, '
                    'mang đến trải nghiệm mua sắm tiện lợi với đa dạng sản phẩm thiết yếu hàng ngày. '
                    'Chúng tôi cam kết cung cấp sản phẩm chất lượng, giá cả phải chăng và dịch vụ tận tâm.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Sản phẩm chính
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: Row(
                children: [
                  Icon(Icons.category_rounded, color: Colors.green, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Sản phẩm chính',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              delegate: SliverChildListDelegate([
                _buildProductCategoryCard(
                  '🍚 Gạo & Ngũ cốc',
                  'Gạo trắng, gạo lứt, bột mì...',
                  Colors.amber.shade100,
                  Colors.amber.shade700,
                ),
                _buildProductCategoryCard(
                  '🥫 Đồ hộp & Gia vị',
                  'Nước mắm, dầu ăn, gia vị...',
                  Colors.orange.shade100,
                  Colors.orange.shade700,
                ),
                _buildProductCategoryCard(
                  '🍜 Mì & Snack',
                  'Mì gói, bánh kẹo, snack...',
                  Colors.red.shade100,
                  Colors.red.shade700,
                ),
                _buildProductCategoryCard(
                  '🥤 Nước giải khát',
                  'Nước ngọt, sữa, nước trái cây...',
                  Colors.blue.shade100,
                  Colors.blue.shade700,
                ),
                _buildProductCategoryCard(
                  '🧴 Đồ dùng cá nhân',
                  'Xà phòng, dầu gội, kem đánh răng...',
                  Colors.purple.shade100,
                  Colors.purple.shade700,
                ),
                _buildProductCategoryCard(
                  '🧹 Vệ sinh nhà cửa',
                  'Nước giặt, nước rửa chén...',
                  Colors.teal.shade100,
                  Colors.teal.shade700,
                ),
              ]),
            ),
          ),

          // 4. Điểm nổi bật
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 16),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Tại sao chọn chúng tôi?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildFeatureCard(
                    Icons.verified_outlined,
                    'Sản phẩm chính hãng',
                    'Cam kết 100% hàng chính hãng, nguồn gốc rõ ràng',
                    Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    Icons.local_offer_outlined,
                    'Giá cả phải chăng',
                    'Giá tốt nhất khu vực, nhiều chương trình khuyến mãi',
                    Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    Icons.access_time_rounded,
                    'Mở cửa cả ngày',
                    'Phục vụ từ 6:00 sáng đến 10:00 tối hàng ngày',
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    Icons.delivery_dining_outlined,
                    'Giao hàng tận nơi',
                    'Miễn phí giao hàng trong bán kính 2km',
                    Colors.red,
                  ),
                ],
              ),
            ),
          ),

          // 5. Thông tin liên hệ
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade400],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.contact_phone_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Liên hệ với chúng tôi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildContactRow(Icons.phone, 'Hotline: 0123.456.789'),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.location_on, 'Địa chỉ: 123 Đường ABC, Quận XYZ, TP.HCM'),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.email, 'Email: taphoa.mini@gmail.com'),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.schedule, 'Giờ mở cửa: 6:00 - 22:00 (T2-CN)'),
                ],
              ),
            ),
          ),

          // 6. Nút bắt đầu
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 40),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: Colors.green.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_rounded, size: 24),
                          SizedBox(width: 12),
                          Text(
                            'BẮT ĐẦU MUA SẮM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Đăng nhập để trải nghiệm mua sắm trực tuyến',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  Text(
                    '© 2026 Tạp Hóa Mini',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mua sắm tiện lợi - Giao hàng nhanh chóng',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCategoryCard(String title, String subtitle, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withOpacity(0.8),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}