import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/custom_header.dart';
import '../profile/profile_screen.dart';
import 'favorites_page.dart';
import 'cart_page.dart';
import 'home_screen.dart';
import 'clients_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 3;

  final List<Widget> _pages = const [
    ProfileScreen(),
    FavoritesPage(),
    CartPage(),
    HomeScreen(),
    ClientsPage(),
  ];

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F4F7),
        body: _pages[_selectedIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () {
            _onBottomNavTap(3);
          },
          elevation: 2,
          backgroundColor: Colors.black,
          child: const Icon(Icons.home, color: Colors.white),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          elevation: 8,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomItem(
                  icon: Icons.person_outline,
                  isActive: _selectedIndex == 0,
                  onTap: () => _onBottomNavTap(0),
                ),
                _buildBottomItem(
                  icon: Icons.receipt_long_outlined,
                  isActive: _selectedIndex == 1,
                  onTap: () => _onBottomNavTap(1),
                ),
                const SizedBox(width: 40),
                _buildBottomItem(
                  icon: Icons.bar_chart_outlined,
                  isActive: _selectedIndex == 2,
                  onTap: () => _onBottomNavTap(2),
                ),
                _buildBottomItem(
                  icon: Icons.people_outline,
                  isActive: _selectedIndex == 4,
                  onTap: () => _onBottomNavTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required VoidCallback onTap,
    required bool isActive,
  }) {
    final color = isActive ? Colors.red : Colors.grey;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 2),
          Container(
            height: 2,
            width: 20,
            decoration: BoxDecoration(
              color: isActive ? Colors.red : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
