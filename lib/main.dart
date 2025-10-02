import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/home/bottom_nav.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(prefs: prefs));
}

// Theme moved to core/theme/app_theme.dart

// CustomLogoutDialog moved to shared/widgets/custom_dialogs.dart

// CustomHeader moved to shared/widgets/custom_header.dart

// ClientsPage moved to features/home/clients_page.dart

// BottomNavBar moved to features/home/bottom_nav.dart

// LocaleProvider moved to core/providers/locale_provider.dart

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
        locale: _locale,
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ar', 'AE'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: '/',
      ),
    );
  }
}
// RegistrationScreen moved to features/auth/registration_screen.dart

// LoginScreen moved to features/auth/login_screen.dart

// AppColors moved to core/constants/app_colors.dart

// Version label moved into profile screen

// CustomUserData moved to shared/widgets/user_summary_card.dart

// FavoritesPage moved to features/home/favorites_page.dart

// AddProduct placeholder removed (unused)

// CartPage moved to features/home/cart_page.dart

// HomeScreen moved to features/home/home_screen.dart

// ProfileScreen moved to features/profile/profile_screen.dart

// DatabaseHelper moved to core/services/database_helper.dart

// ChangePasswordScreen moved to features/security/change_password_screen.dart

// SplashScreen kept simple; consider moving to features/splash if needed
