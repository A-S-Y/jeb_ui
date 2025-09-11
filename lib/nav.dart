// import 'package:smart_management/core/imports/imports.dart';

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => CustomLogoutDialog(
//         ctx,
//         onLogout: () {
//           Navigator.pop(ctx);
//           // TODO: أضف كود تسجيل الخروج هنا
//         },
//         onCancel: () => Navigator.pop(ctx),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF2F4F7),
//         appBar: AppBar(
//           title: const Text('البروفايل', style: TextStyle(color: Colors.black)),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           iconTheme: const IconThemeData(color: Colors.black),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 20),
//               const CircleAvatar(
//                 radius: 45,
//                 backgroundColor: Colors.grey,
//                 backgroundImage: AssetImage("assets/avatar.png"),
//               ),
//               const SizedBox(height: 12),
//               const Text(
//                 "أحمد محمد",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 "ahmed@email.com",
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//               const SizedBox(height: 20),

//               // عناصر تم نقلها إلى شاشة البروفايل
//               _buildSectionCard(
//                 child: SettingsItem(
//                   icon: Icons.settings_outlined,
//                   label: "الإعدادات",
//                   onTap: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => const SettingsScreen()),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildSectionCard(
//                 child: SettingsItem(
//                   icon: Icons.backup_outlined,
//                   label: "النسخ الاحتياطي",
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (_) => const AlertDialog(
//                       title: Text('قريباً'),
//                       content: Text('هذه الميزة ستكون متاحة في الإصدارات القادمة.'),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildSectionCard(
//                 child: SettingsItem(
//                   icon: Icons.help_outline,
//                   label: "المساعدة",
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (_) => const AlertDialog(
//                       title: Text('المساعدة'),
//                       content: Text(
//                         'كيفية استخدام التطبيق:\n\n1. أضف عميل جديد من الشاشة الرئيسية\n2. اضغط على العميل لإدارة معاملاته\n3. أضف معاملة جديدة (لك/عليك)\n4. استخدم القائمة لتعديل أو حذف أو طباعة\n5. استخدم البحث للعثور على العملاء أو المعاملات',
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildSectionCard(
//                 child: SettingsItem(
//                   icon: Icons.info_outline,
//                   label: "حول التطبيق",
//                   onTap: () => showDialog(
//                     context: context,
//                     builder: (_) => const AlertDialog(
//                       title: Center(child: Text('حول التطبيق')),
//                       content: Text(
//                         'Smart Management\nتطبيق لإدارة العملاء والمعاملات المالية\nمطور باستخدام Flutter',
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 18),

//               // بقية عناصر البروفايل (تعديل الحساب، تغيير كلمة المرور، تسجيل الخروج..)
//               _buildSectionCard(
//                 child: const SettingsItem(
//                   icon: Icons.edit,
//                   label: "تعديل الحساب",
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildSectionCard(
//                 child: const SettingsItem(
//                   icon: Icons.lock,
//                   label: "تغيير كلمة المرور",
//                 ),
//               ),
//               const SizedBox(height: 6),
//               _buildSectionCard(
//                 child: SettingsItem(
//                   icon: Icons.logout,
//                   label: "تسجيل الخروج",
//                   onTap: () => _showLogoutDialog(context),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionCard({required Widget child}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       padding: const EdgeInsets.symmetric(vertical: 0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 0),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }
// }


// class SettingsItem extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback? onTap;
//   final String? trailingText;

//   const SettingsItem({
//     super.key,
//     required this.icon,
//     required this.label,
//     this.onTap,
//     this.trailingText,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         child: Row(
//           children: [
//             Container(
//               width: 40,
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, size: 20, color: Colors.black87),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 label,
//                 style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
//               ),
//             ),
//             if (trailingText != null) ...[
//               Text(
//                 trailingText!,
//                 style: TextStyle(color: Colors.grey[600], fontSize: 13),
//               ),
//               const SizedBox(width: 6),
//             ],
//             const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CustomLogoutDialog extends StatelessWidget {
//   final String title;
//   final String message;
//   final VoidCallback onLogout;
//   final VoidCallback onCancel;

//   const CustomLogoutDialog(BuildContext ctx, {
//     super.key,
//     this.title = "تأكيد!",
//     this.message = "هل تريد الخروج من التطبيق؟",
//     required this.onLogout,
//     required this.onCancel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               title,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 22,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 15),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25),
//               child: Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: onCancel,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white.withOpacity(0.9),
//                       foregroundColor: Colors.grey[800],
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text("إلغاء",),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: onLogout,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text(
//                       "حسناً",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
