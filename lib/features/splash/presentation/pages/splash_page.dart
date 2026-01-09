import 'package:camera_v1/config/routes/app_routes.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    // Artificial delay for smoother experience (displaying branding)
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.read<AuthBloc>().add(CheckAuthStatusEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else if (state is AuthInitial || state is AuthError) {
          final prefs = await SharedPreferences.getInstance();
          final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
          if (context.mounted) {
            if (seenOnboarding) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
            }
          }
        }
      },
      child: Scaffold(
        // ... (existing body)
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Camera Security',
                style: AppTheme.headingLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
