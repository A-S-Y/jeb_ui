import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/locale_provider.dart';
import '../../shared/widgets/custom_dialogs.dart';
import '../../shared/widgets/user_summary_card.dart';
import '../../shared/widgets/custom_header.dart';
import '../security/change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _buildExpandableMenuItem(
      IconData icon, String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.kContentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        iconColor: AppColors.kTextAndIconColor,
        showTrailingIcon: true,
        leading: Icon(
          icon,
          color: AppColors.kTextAndIconColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.kTextAndIconColor,
          ),
        ),
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              thickness: 1,
              indent: 10,
              endIndent: 10,
              color: AppColors.kTextAndIconColor.withOpacity(0.3),
            );
          } else {
            return children[index ~/ 2];
          }
        }),
      ),
    );
  }

  Widget _buildSubMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.kTextAndIconColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.kContentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? AppColors.kprimaryColor : AppColors.kTextAndIconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? AppColors.kprimaryColor : AppColors.kTextAndIconColor,
          ),
        ),
        onTap: () {
          if (isLogout) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CustomLogoutDialog(
                  context,
                  onLogout: () {
                    Navigator.pop(context);
                    SystemNavigator.pop();
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(Icons.update, 'تحديث بيانات التطبيق'),
        _buildMenuItem(Icons.phone_android, 'ادارة الأجهزة'),
        _buildExpandableMenuItem(
          Icons.security,
          'الخصوصية والأمان',
          [
            _buildSubMenuItem(Icons.phone, 'تغيير رمز التاكيد', () {}),
            _buildSubMenuItem(Icons.lock, 'تغيير كلمة المرور', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            }),
            _buildSubMenuItem(Icons.fingerprint_outlined, 'استخدم البصمة لتسجيل الدخول ', () {}),
            _buildSubMenuItem(Icons.security, ' اخفاء الاقتراخات ', () {}),
            _buildSubMenuItem(Icons.info, 'الشروط والاحكام', () {}),
          ],
        ),
        _buildExpandableMenuItem(
          Icons.headset_mic,
          'الدعم والمساعدة',
          [
            _buildSubMenuItem(Icons.phone, '8008005', () {}),
            _buildSubMenuItem(Icons.location_on_outlined, 'نقاط الخدمة', () {}),
            _buildSubMenuItem(Icons.support_agent, 'خدمة العملاء', () {}),
          ],
        ),
        _buildMenuItem(Icons.share, 'شارك تطبيق جيب'),
        _buildMenuItem(Icons.sunny, 'مظهر التطبيق'),
        _buildLanguageSwitcher(context),
        _buildMenuItem(Icons.delete_outline, 'طلب الغاء المحفظة'),
        _logoutMenuItem(),
      ],
    );
  }

  Widget _logoutMenuItem() {
    return _buildMenuItem(
      Icons.logout,
      'تسجيل الخروج',
      isLogout: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kscaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: const [
                CustomHeader(
                  userName: 'فارع',
                ),
                CustomUserData(
                  userName: 'فارع عبده فارع محمد الضلاع',
                  accountNumber: '717281413',
                  alternateNumber: '886368',
                ),
                _MenuItems(),
                _VersionLabel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.kContentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.language),
        title: const Text('تغيير اللغة'),
        onTap: () {
          _showLanguageDialog(context);
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            decoration: const BoxDecoration(
              color: AppColors.kContentColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24),
                      const Text(
                        'حدد اللغة',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF222222),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        color: const Color(0xFF222222),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('عربي'),
                    onTap: () {
                      context.read<LocaleProvider>().setLocale(const Locale('ar', 'AE'));
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('إنجليزي'),
                    onTap: () {
                      context.read<LocaleProvider>().setLocale(const Locale('en', 'US'));
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MenuItems extends StatelessWidget {
  const _MenuItems();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_ProfileScreenState>()!;
    return state._buildMenuItems();
  }
}

class _VersionLabel extends StatelessWidget {
  const _VersionLabel();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Text(
        'V 2.6',
        style: TextStyle(color: AppColors.kTextAndIconColor, fontSize: 18),
      ),
    );
  }
}
