// ignore_for_file: use_build_context_synchronously

import 'package:camera_v1/core/presentation/widgets/animated_background.dart';
import 'package:camera_v1/core/presentation/widgets/fade_slide_transition.dart';
import 'package:camera_v1/core/presentation/widgets/scale_button.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:camera_v1/features/auth/presentation/pages/login_page.dart';
import 'package:camera_v1/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: AppTheme.bodyMedium),
                backgroundColor: AppTheme.successColor,
                duration: const Duration(seconds: 3),
              ),
            );
            // Navigate back after showing success message
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ResetPasswordPage(email: _emailController.text.trim()),
                  ),
                );
              }
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: AppTheme.bodyMedium),
                backgroundColor: AppTheme.dangerColor,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          return AnimatedBackground(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 32.0 : 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      FadeSlideTransition(
                        delay: Duration.zero,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icon(
                              Icons.arrow_back,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Title
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          AppLocalizations.of(
                            context,
                          ).translate('forgot_password_page_title'),
                          style: AppTheme.headingLarge.copyWith(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 40 : 32,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: isTablet ? 60 : 40),

                      // Illustration container
                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 200),
                        child: Center(
                          child: Container(
                            width: isTablet ? 200 : 150,
                            height: isTablet ? 200 : 150,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.12),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.2),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Main padlock icon
                                Icon(
                                  Icons.lock_outlined,
                                  size: isTablet ? 80 : 60,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                // Decorative circles
                                Positioned(
                                  top: 20,
                                  right: 30,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 30,
                                  left: 20,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  left: 25,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: isTablet ? 60 : 40),

                      FadeSlideTransition(
                        delay: const Duration(milliseconds: 300),
                        child: Column(
                          children: [
                            // Subtitle
                            Text(
                              AppLocalizations.of(
                                context,
                              ).translate('forgot_password'),
                              style: AppTheme.headingMedium.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onBackground,
                                fontWeight: FontWeight.bold,
                                fontSize: isTablet ? 28 : 24,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              AppLocalizations.of(
                                context,
                              ).translate('forgot_password_instruction'),
                              style: AppTheme.bodyMedium.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: isTablet ? 16 : 14,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            SizedBox(height: isTablet ? 40 : 32),

                            // Email input field
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(
                                      context,
                                    ).translate('email'),
                                    style: AppTheme.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(
                                        context,
                                      ).translate('email_hint'),
                                      hintStyle: AppTheme.bodyMedium.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.4),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                      filled: true,
                                      fillColor: Theme.of(
                                        context,
                                      ).colorScheme.surface.withOpacity(0.5),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    style: AppTheme.bodyLarge,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppLocalizations.of(
                                          context,
                                        ).translate('error_email');
                                      }
                                      if (!value.contains('@')) {
                                        return AppLocalizations.of(
                                          context,
                                        ).translate('error_email_valid');
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (_) =>
                                        _handleSendResetCode(),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isTablet ? 32 : 24),

                            // Send Reset Code button
                            ScaleButton(
                              child: ElevatedButton(
                                onPressed: _handleSendResetCode,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  minimumSize: const Size(double.infinity, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).translate('send_reset_code'),
                                  style: AppTheme.labelLarge.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: isTablet ? 40 : 32),

                            // Remember Password link
                            Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(
                                        context,
                                      ).translate('remember_password_question'),
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          if (Navigator.of(context).canPop()) {
                                            Navigator.of(context).pop();
                                          } else {
                                            Navigator.of(
                                              context,
                                            ).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage(),
                                              ),
                                              (route) => false,
                                            );
                                          }
                                        },
                                        child: Text(
                                          AppLocalizations.of(
                                            context,
                                          ).translate('login_tab'),
                                          style: AppTheme.bodyMedium.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Need Help link
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    size: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                  const SizedBox(width: 4),
                                  TextButton(
                                    onPressed: () {
                                      // Navigate to help page
                                    },
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      ).translate('need_help_question'),
                                      style: AppTheme.bodySmall.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSendResetCode() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(
        context,
      ).add(ForgotPasswordEvent(email: _emailController.text.trim()));
    }
  }
}
