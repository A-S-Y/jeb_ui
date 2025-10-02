import 'package:flutter/material.dart';
import '../../features/home/bottom_nav.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/registration_screen.dart';

class AppRouteNames {
  static const String root = '/';
  static const String login = '/login';
  static const String register = '/register';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.root:
        return MaterialPageRoute(builder: (_) => const BottomNavBar());
      case AppRouteNames.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRouteNames.register:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
