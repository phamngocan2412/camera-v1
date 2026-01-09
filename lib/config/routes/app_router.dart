import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/verification_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart'; // Import OnboardingPage
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.verification:
        final args = settings.arguments;
        String email = '';
        if (args is String) {
          email = args;
        } else {
          // Log or handle error if needed, for now just use empty string
          // developer.log('Invalid arguments for verification route: $args');
        }
        return MaterialPageRoute(
          builder: (_) => VerificationPage(email: email),
        );

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
