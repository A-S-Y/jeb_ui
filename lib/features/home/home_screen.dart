import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/custom_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isBalanceHidden = false;
  int _cardPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.9);

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return "صباح الخير";
    if (hour >= 12 && hour < 17) return "مساء الخير";
    return "مساء الخير";
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _pullToRefreshHint() {
    return const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "اسحب للأسفل للتحديث",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(width: 6),
              Icon(
                Icons.keyboard_double_arrow_down_rounded,
                size: 12,
                color: Colors.grey,
              ),
            ],
          ),
        ));
  }

  Widget _accountCard({
    required Color color,
    required String titleRight,
    required String walletName,
    required bool offline,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: -10,
            bottom: -6,
            child: Opacity(
              opacity: 0.15,
              child: Icon(Icons.blur_on, color: Colors.white, size: 120),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "جيب jaib",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("حساب",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      Text(
                        titleRight,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    _isBalanceHidden ? "•••••" : "1,250.00 ر.ي",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => setState(() => _isBalanceHidden = !_isBalanceHidden),
                    child: Icon(
                      _isBalanceHidden ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Text(
                          offline ? "Offline" : "Online",
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          offline ? Icons.wifi_off_rounded : Icons.wifi_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.visibility_off, size: 20, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardsCarousel() {
    final items = [
      _accountCard(
        color: AppColors.kprimaryColor,
        titleRight: "ريال يمني",
        walletName: "جيب",
        offline: true,
      ),
      _accountCard(
        color: const Color(0xFF232323),
        titleRight: "ريال سعودي",
        walletName: "جيب",
        offline: false,
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (i) => setState(() => _cardPage = i),
            itemBuilder: (_, i) => items[i],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            items.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _cardPage == i ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: _cardPage == i
                    ? AppColors.kprimaryColor
                    : AppColors.kunselectedItemColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _offlineBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.kprimaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.offline_bolt_rounded, color: AppColors.kprimaryColor),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "جيب بدون نت",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.kTextAndIconColor,
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 4),
                Text(
                  "خدماتك عبر الرسائل النصية",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE8E8EA)),
            ),
            child: const Row(
              children: [
                Text("Offline", style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(width: 6),
                Icon(Icons.wifi_off_rounded, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _serviceItem(IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kContentColor,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.kTextAndIconColor, size: 28),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.kTextAndIconColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _servicesGrid() {
    final items = <Widget>[
      _serviceItem(Icons.receipt_long_outlined, "الشحن والسداد"),
      _serviceItem(Icons.sync_alt_outlined, "حزمي تحويل"),
      _serviceItem(Icons.autorenew_outlined, "تحويلات مالية"),
      _serviceItem(Icons.account_balance_wallet_outlined, "سحب نقدي"),
      _serviceItem(Icons.shopping_bag_outlined, "دفع المشتريات"),
      _serviceItem(Icons.contactless_outlined, "شراء اونلاين"),
      _serviceItem(Icons.shield_outlined, "جيبي"),
      _serviceItem(Icons.sports_esports_outlined, "خدمات ترفيـه"),
      _serviceItem(Icons.account_balance_wallet, "المدفوعات"),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (_, i) => items[i],
      ),
    );
  }

  Widget _operationsEmpty() {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: const [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "العمليات",
              style: TextStyle(
                color: AppColors.kTextAndIconColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 14),
          _OperationsPlaceholder(),
          SizedBox(height: 90),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kscaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 80,
        title: const CustomHeader(userName: "فارع"),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.kprimaryColor,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _pullToRefreshHint()),
              SliverToBoxAdapter(child: _cardsCarousel()),
              SliverToBoxAdapter(child: _offlineBanner()),
              SliverToBoxAdapter(child: _servicesGrid()),
              SliverToBoxAdapter(child: _operationsEmpty()),
            ],
          ),
        ),
      ),
    );
  }
}

class _OperationsPlaceholder extends StatelessWidget {
  const _OperationsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.kTextAndIconColor),
          SizedBox(height: 12),
          Text(
            "لا يوجد عمليات",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.kTextAndIconColor,
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              "قم بالتحويل أو دفع مشترياتك عن طريق محفظة جيب لمشاهدة عملياتك",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
