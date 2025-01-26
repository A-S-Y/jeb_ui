import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(prefs: prefs));
}

class AppTheme {
  /// Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo', // 👈 Cairo افتراضي
      colorScheme: _lightColorScheme,
      appBarTheme: _lightAppBarTheme,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      inputDecorationTheme: _inputDecorationTheme(Colors.black),
      elevatedButtonTheme: _elevatedButtonTheme(Colors.white, Colors.redAccent),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        Colors.white,
        const Color.fromARGB(0, 28, 57, 65),
      ),
      textTheme: _getTextTheme(),
      splashFactory: InkRipple.splashFactory,
      splashColor: Colors.red.withOpacity(0.08),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.red,
        selectionColor: Colors.red.withOpacity(0.6),
        cursorColor: Colors.red,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color.fromARGB(255, 242, 104, 77),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Cairo',
      colorScheme: _darkColorScheme,
      appBarTheme: _darkAppBarTheme,
      scaffoldBackgroundColor: Colors.black,
      cardColor: const Color.fromARGB(255, 57, 57, 57),
      inputDecorationTheme: _inputDecorationTheme(Colors.white),
      elevatedButtonTheme: _elevatedButtonTheme(Colors.white, Colors.black),
      floatingActionButtonTheme: _floatingActionButtonTheme(
        const Color.fromARGB(255, 57, 57, 57),
        Colors.white,
      ),
      textTheme: _getTextTheme(),
      splashFactory: InkRipple.splashFactory,
      splashColor: Colors.red.withOpacity(0.08),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Colors.red,
        selectionColor: Colors.red.withOpacity(0.6),
        cursorColor: Colors.red,
      ),
    );
  }

  /// Light Color Scheme
  static const ColorScheme _lightColorScheme = ColorScheme(
    primary: Colors.black,
    secondary: Colors.black,
    surface: Colors.white,
    error: Color.fromARGB(255, 242, 104, 77),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  /// Dark Color Scheme
  static const ColorScheme _darkColorScheme = ColorScheme(
    primary: Colors.white,
    secondary: Colors.white,
    surface: Colors.black,
    error: Color.fromARGB(255, 242, 104, 77),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  );

  /// AppBar Theme
  static const AppBarTheme _lightAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
  );

  /// Dark AppBar Theme
  static const AppBarTheme _darkAppBarTheme = AppBarTheme(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
  );

  /// Input Decoration Theme
  static InputDecorationTheme _inputDecorationTheme(Color borderColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  /// Elevated Button Theme
  static ElevatedButtonThemeData _elevatedButtonTheme(
      Color backgroundColor, Color foregroundColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Floating Action Button Theme
  static FloatingActionButtonThemeData _floatingActionButtonTheme(
      Color backgroundColor, Color foregroundColor) {
    return FloatingActionButtonThemeData(
      shape: const CircleBorder(),
      elevation: 1,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
    );
  }

  /// Get Text Theme
  static TextTheme _getTextTheme() {
    const fontFamily = 'Cairo';
    return const TextTheme(
      displayLarge: const TextStyle(
        fontFamily: fontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

class CustomLogoutDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onLogout;
  final VoidCallback onCancel;

  const CustomLogoutDialog(
    BuildContext context, {
    super.key,
    this.title = "هل تريد تسجيل الخروج؟",
    this.message = "سوف تتمكن من تسجيل الدخول لاحقًا باستخدام حسابك.",
    required this.onLogout,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // حواف مستديرة
      ),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: AppColors.kContentColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout_rounded,
              size: 60,
              color: AppColors.kprimaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.kTextAndIconColor,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kContentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "إلغاء",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kTextAndIconColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kprimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      "تسجيل الخروج",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.kContentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomHeader extends StatelessWidget {
  final String userName;

  const CustomHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "طاب مساءك",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextAndIconColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kTextAndIconColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Card(
            color: AppColors.kContentColor,
            child: IconButton(
              icon: const Icon(Icons.notifications_rounded,
                  color: AppColors.kprimaryColor),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 3; // البداية Home

  final List<Widget> _pages = [
    const ProfileScreen(), // 0
    const FavoritesPage(), // 1
    const CartPage(), // 2
    const HomeScreen(), // 3
    const ClientsPage(), // 4
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
            _onBottomNavTap(3); // Home
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
                const SizedBox(width: 40), // Space for FAB
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
          // الخط الأحمر تحت الأيقونة عند التفعيل
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

class LocaleProvider with ChangeNotifier {
  Locale _locale;
  final SharedPreferences prefs;

  LocaleProvider(this.prefs)
      : _locale = Locale(prefs.getString('language_code') ?? 'ar') {
    _loadLocale();
  }

  Locale get locale => _locale;

  // Load locale from SharedPreferences
  Future<void> _loadLocale() async {
    final languageCode = prefs.getString('language_code') ?? 'ar';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  // Toggle locale between 'en' and 'ar'
  void toggleLocale() {
    if (_locale.languageCode == 'en') {
      _locale = const Locale('ar', 'AE');
    } else {
      _locale = const Locale('en', 'US');
    }
    // Save the new locale to SharedPreferences
    prefs.setString('language_code', _locale.languageCode);
    notifyListeners();
  }

  // Set a specific locale
  void setLocale(Locale locale) {
    _locale = locale;
    prefs.setString('language_code', locale.languageCode);
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  _MyAppState createState() => _MyAppState();
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.prefs.getString('language_code') ?? 'en');
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    widget.prefs.setString('language_code', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocaleProvider(widget.prefs),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: _locale, // Use the current locale
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'AE'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const BottomNavBar(),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _acceptTerms = false;
  String _selectedGender = '';
  String initialCountry = 'YE';
  PhoneNumber number = PhoneNumber(isoCode: 'YE');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/images/jaiblogo.png',
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'مرحبًا بك في جيب',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansArabic',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'قم بإنشاء حسابك، وانضم إلى عملاء جيب',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'قم بادخال الاسم كما في الهوية*',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.kprimaryColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansArabic',
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'الاسم الثاني',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'الاسم الأول',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'اللقب ',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: ' الاسم الثالث',
                      labelStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {},
                            onInputValidated: (bool isValid) {},
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              useEmoji: false,
                              useBottomSheetSafeArea: true,
                            ),
                            initialValue: number,
                            textFieldController: TextEditingController(),
                            inputDecoration: const InputDecoration(
                              border:
                                  InputBorder.none, // إخفاء الحدود الافتراضية
                              hintText: 'أدخل رقم الموبايل',
                            ),
                            countries: const [
                              'YE',
                              'SA',
                              'AE',
                              'EG',
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGender = 'female'),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedGender == 'female'
                              ? Colors.black
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_outline),
                          SizedBox(width: 10),
                          Text('أنثى'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGender = 'male'),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedGender == 'male'
                              ? Colors.black
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person),
                          SizedBox(width: 10),
                          Text('ذكر'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('أوافق على الشروط والأحكام'),
                Checkbox(
                  activeColor: AppColors.kprimaryColor,
                  value: _acceptTerms,
                  onChanged: (value) {
                    setState(() {
                      _acceptTerms = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kprimaryColor,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'إنشاء حساب',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    ' سجل دخول',
                    style: TextStyle(color: AppColors.kprimaryColor),
                  ),
                ),
                const Text(' لديك حساب بالفعل؟'),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePin = true;
  String _selectedAccountType = '';
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pinController.addListener(_onPinChanged);
  }

  void _onPinChanged() {
    setState(() {});
  }

  Future<void> _authenticateWithPin() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال رقم الموبايل")),
      );
      return;
    }

    // التحقق من الاتصال بالإنترنت
    bool hasInternet = await _checkInternetConnectionWithRetry();
    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("لا يوجد اتصال بالإنترنت. تحقق من اتصالك.")),
      );
      return;
    }

    // التحقق من رمز PIN
    if (_pinController.text == '1234') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomNavBar(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("رمز PIN غير صحيح")),
      );
    }
  }

  Future<void> authenticateWithBiometrics(BuildContext context) async {
    final LocalAuthentication localAuth = LocalAuthentication();
    try {
      bool isAuthenticated = await localAuth.authenticate(
        localizedReason: "قم بتأكيد الهوية باستخدام البصمة",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        bool hasInternet = await _checkInternetConnectionWithRetry();

        if (hasInternet) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم التحقق بنجاح")),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("خطأ في الاتصال"),
              content: const Text(
                  "لا يوجد اتصال بالإنترنت. تحقق من اتصالك وحاول مرة أخرى."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("حسناً"),
                ),
              ],
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("فشل التحقق")),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: ${e.message}")),
      );
    }
  }

  Future<bool> _checkInternetConnectionWithRetry() async {
    const int maxRetries = 3;
    int attempt = 0;

    while (attempt < maxRetries) {
      bool hasConnection = await InternetConnectionCheckerPlus().hasConnection;
      if (hasConnection) {
        return true;
      }
      attempt++;
      await Future.delayed(const Duration(seconds: 2));
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Image.asset(
                'assets/images/jaiblogo.png',
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              'مرحبًا بعودتك ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'IBMPlexSansArabic',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'قم بتسجيل الدخول ',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedAccountType = 'customer'),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedAccountType == 'customer'
                                ? Colors.black
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_outline),
                            SizedBox(width: 10),
                            Text('عميل'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedAccountType = 'sales_point'),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedAccountType == 'sales_point'
                                ? Colors.black
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.store_outlined),
                            SizedBox(width: 10),
                            Text('نقطة مبيعات'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'رقم الموبايل',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              obscureText: _obscurePin,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'رمز PIN',
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                suffixIcon: _pinController.text.isEmpty
                    ? IconButton(
                        onPressed: () {
                          authenticateWithBiometrics(context);
                        },
                        icon: const Icon(
                          Icons.fingerprint,
                          size: 30,
                          color: Colors.grey,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePin = !_obscurePin;
                          });
                        },
                        icon: Icon(
                          _obscurePin ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _authenticateWithPin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kprimaryColor,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegistrationScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'إنشاء حساب',
                    style: TextStyle(color: AppColors.kprimaryColor),
                  ),
                ),
                const Text('لاتمتلك حساب؟'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppColors {
  static const Color kContentColor = Color(0xfffdfdfd);
  static const Color kConteDDDDDntColor = Color(0xFFFEF7FF);
  static const Color kContenBBBBtColor = Color(0xFF141218);
  static const Color kscaffoldBackgroundColor = Color(0xfff1f0f5);
  static const Color kprimaryColor = Color(0xffcb0a09);
  static const Color kTextAndIconColor = Color(0xFF1C3941);
  static const Color kunselectedItemColor = Color(0xFF8E8D90);
  static const Color kunselecgggtedItemColor = Color(0xFFBDBDBE);
}

class CustomVersion extends StatelessWidget {
  const CustomVersion({super.key});
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

class CustomUserData extends StatelessWidget {
  final String userName;
  final String accountNumber;
  final String alternateNumber;

  const CustomUserData({
    super.key,
    required this.userName,
    required this.accountNumber,
    required this.alternateNumber,
  });

  Widget _buildAccountInfo(String label, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.kContentColor)),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.kContentColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.kContentColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.kTextAndIconColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.kprimaryColor, width: 3),
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.kContentColor,
                  child: Icon(Icons.person_outline,
                      size: 40, color: AppColors.kprimaryColor),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                userName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: AppColors.kprimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                _buildAccountInfo('رقم الحساب', accountNumber),
                const VerticalDivider(
                  color: AppColors.kContentColor,
                  width: 1,
                  thickness: 1,
                ),
                _buildAccountInfo('الرقم البديل', alternateNumber),
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.kTextAndIconColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      const Icon(Icons.qr_code, color: AppColors.kContentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Favorites Page'),
      ),
    );
  }
}

class AddProduct extends StatelessWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Add Product Page'),
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Cart Page'),
      ),
    );
  }
}

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
    // ضع هنا منطق التحديث (جلب رصيد/حركات…)
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

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _greeting(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.kTextAndIconColor,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "            فارع",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kTextAndIconColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Card(
            color: AppColors.kContentColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none_rounded,
                  color: AppColors.kprimaryColor, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pullToRefreshHint() {
    return const Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
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
        )

    );
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
          // زخرفة خفيفة
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
              // شعار واسم
              Row(
                children: [
                  // مكان شعار جيب
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined,
                            color: Colors.white, size: 18),
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
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // الرصيد
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
                    onTap: () =>
                        setState(() => _isBalanceHidden = !_isBalanceHidden),
                    child: Icon(
                      _isBalanceHidden
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // حالة الاتصال
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    child: const Icon(Icons.visibility_off,
                        size: 20, color: Colors.white),
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
          // صورة توضيحية بسيطة
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.kprimaryColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.offline_bolt_rounded,
                color: AppColors.kprimaryColor),
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
        children: [
          const Align(
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
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F4F6),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              children: [
                Icon(Icons.inventory_2_outlined,
                    size: 64, color: AppColors.kTextAndIconColor),
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
          ),
          const SizedBox(height: 90), // فراغ لأسفل قبل البار السفلي
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
        toolbarHeight: 80, // ارتفاع أكبر عشان الـ CustomHeader
        title: const CustomHeader(userName: "فارع"),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   titleSpacing: 0,
      //   title: Row(
      //     children: [
      //       // التحية + الاسم
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.end,
      //         children: [
      //           Text(
      //             _greeting(),
      //             style: const TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.w800,
      //               color: AppColors.kTextAndIconColor,
      //             ),
      //           ),
      //           const SizedBox(height: 4),
      //           const Text(
      //             "فارع",
      //             style: TextStyle(
      //               fontSize: 18,
      //               fontWeight: FontWeight.w600,
      //               color: AppColors.kTextAndIconColor,
      //             ),
      //           ),
      //         ],
      //       ),
      //       const Spacer(),
      //       // زر الإشعارات
      //       Card(
      //         color: AppColors.kContentColor,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(12),
      //         ),
      //         elevation: 0,
      //         child: IconButton(
      //           onPressed: () {},
      //           icon: const Icon(
      //             Icons.notifications_none_rounded,
      //             color: AppColors.kprimaryColor,
      //             size: 28,
      //           ),
      //         ),
      //       ),
      //       const SizedBox(width: 12),
      //     ],
      //   ),
      // ),

      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.kprimaryColor,
          onRefresh: _onRefresh,
          child: CustomScrollView(
            // physics: const AlwaysScrollableScrollPhysics(
            //   parent: BouncingScrollPhysics(),
            // ),
            slivers: [
              // نحذف SliverToBoxAdapter(child: _header()),
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
          color:
              isLogout ? AppColors.kprimaryColor : AppColors.kTextAndIconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout
                ? AppColors.kprimaryColor
                : AppColors.kTextAndIconColor,
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
            _buildSubMenuItem(Icons.fingerprint_outlined,
                'استخدم البصمة لتسجيل الدخول ', () {}),
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
              children: [
                const CustomHeader(
                  userName: 'فارع',
                ),
                const CustomUserData(
                  userName: 'فارع عبده فارع محمد الضلاع',
                  accountNumber: '717281413',
                  alternateNumber: '886368',
                ),
                _buildMenuItems(),
                const CustomVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.kContentColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.language),
        title: Text(
          l10n.changeLanguage,
        ),
        onTap: () {
          _showLanguageDialog(context);
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true, // يتيح التحكم في ارتفاع النافذة المنبثقة
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(
              bottom: 30.0), // رفع النافذة قليلاً عن الحافة السفلية
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
                      Text(
                        l10n.selectlanguage,
                        style: const TextStyle(
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
                    title: Text(l10n.arabic),
                    onTap: () {
                      context
                          .read<LocaleProvider>()
                          .setLocale(const Locale('ar', 'AE'));
                      MyApp.setLocale(context, const Locale('ar', 'AE'));
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.english),
                    onTap: () {
                      context
                          .read<LocaleProvider>()
                          .setLocale(const Locale('en', 'US'));
                      MyApp.setLocale(context, const Locale('en', 'US'));
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

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = p.join(await getDatabasesPath(), 'jeb.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            password TEXT
          )
        ''');
      },
    );
  }

  Future<String?> getStoredPassword() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.query('users', columns: ['password'], limit: 1);
    if (result.isNotEmpty) {
      return result.first['password'];
    }
    return null;
  }

  Future<void> updatePassword(String newPassword) async {
    final db = await database;
    await db.update('users', {'password': newPassword});
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تغيير كلمة المرور'),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور القديمة',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'كلمة المرور الجديدة',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'تأكيد كلمة المرور',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _changePassword,
              child: const Text('تغيير كلمة المرور'),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() async {
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    final storedPassword = await _dbHelper.getStoredPassword();
    if (storedPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء جلب كلمة المرور')),
      );
      return;
    }

    if (_oldPasswordController.text != storedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمة المرور القديمة غير صحيحة')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمتا المرور غير متطابقتين')),
      );
      return;
    }

    // تحديث كلمة المرور في قاعدة البيانات
    await _dbHelper.updatePassword(_newPasswordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
    );

    _clearFields();
  }

  void _clearFields() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002736), // خلفية زرقاء داكنة
      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF002736), // خلفية زرقاء داكنة
                    Color(0xFF002736), // خلفية زرقاء داكنة
                  ],
                ),
              ),
            ),
          ),
          // الشعار مع حركة
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.7 + (_animation.value * 0.3), // تأثير الحركة
                  child: child,
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // تأكد من إضافة الصورة في مجلد assets
                    width: 300,
                    height: 300,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
