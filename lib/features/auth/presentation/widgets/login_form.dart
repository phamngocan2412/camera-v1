import 'package:camera_v1/config/routes/app_routes.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:camera_v1/core/presentation/widgets/scale_button.dart';
import 'package:camera_v1/features/auth/presentation/widgets/verification_required_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../pages/forgot_password_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Check if user is verified
          if (!state.user.isVerified) {
            // Show beautiful verification modal
            VerificationRequiredModal.show(
              context: context,
              email: state.user.email,
              onLater: () {
                // context.read<AuthBloc>().add(LogoutEvent());
              },
            );
          } else {
            // User is verified, proceed to home
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${AppLocalizations.of(context).translate('Welcome')}, ${state.user.firstName} ${state.user.lastName}',
                  style: AppTheme.bodyMedium,
                ),
                backgroundColor: AppTheme.successColor,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          }
        } else if (state is VerificationRequired) {
          // This state is for when backend returns verification pending error
          VerificationRequiredModal.show(
            context: context,
            email: state.email,
            onLater: () {
              // User chose "Later" - stay on login screen
            },
          );
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
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32.0 : 24.0,
            vertical: 8.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Email or Username field
                Text(
                  AppLocalizations.of(context).translate('email_username'),
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      context,
                    ).translate('email_username_hint'),
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.5),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: AppTheme.bodyLarge,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_email_username');
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password field
                Text(
                  AppLocalizations.of(context).translate('password'),
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      context,
                    ).translate('password_hint'),
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  style: AppTheme.bodyLarge,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_password');
                    }
                    if (value.length < 6) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_password_length');
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleLogin(),
                ),

                const SizedBox(height: 8),

                // Forgot Password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage(),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('forgot_password'),
                      style: AppTheme.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Log In button
                ScaleButton(
                  child: ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate('login_tab'),
                      style: AppTheme.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
}
