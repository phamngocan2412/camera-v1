import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:camera_v1/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import 'dart:async';

class ResetPasswordPage extends StatefulWidget {
  final String email;

  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _onVerifyOtp() {
    if (_otpController.text.length == 6) {
      context.read<AuthBloc>().add(
        VerifyResetOtpEvent(email: widget.email, otp: _otpController.text),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
    }
  }

  void _onResendOtp() {
    context.read<AuthBloc>().add(ResendOtpEvent(email: widget.email));
    setState(() {
      _start = 60;
    });
    _startTimer();
  }

  void _showNewPasswordDialog(String otp) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context).translate('reset_password_title'),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _passwordFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          ).translate('new_password'),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(
                                () => _isPasswordVisible = !_isPasswordVisible,
                              );
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            ).translate('error_password_empty');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          ).translate('confirm_password'),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(
                                () => _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible,
                              );
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return AppLocalizations.of(
                              context,
                            ).translate('error_confirm_password_match');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // Cancel
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_passwordFormKey.currentState!.validate()) {
                      // Trigger Reset Password
                      // We need to access the Bloc from the parent context
                      // Note: The dialog context doesn't have the BlocProvider unless we wrap it or use the parent context.
                      // Using the page's Bloc via closure/variable capture if possible, or looking up.
                      // Safest is to use the page's build context or rely on global/existing provider
                      BlocProvider.of<AuthBloc>(this.context).add(
                        ResetPasswordEvent(
                          email: widget.email,
                          otp: otp,
                          newPassword: _newPasswordController.text,
                        ),
                      );
                      // We don't close the dialog here immediately, we wait for success state in the listener.
                    }
                  },
                  child: Text(
                    AppLocalizations.of(
                      context,
                    ).translate('reset_password_button'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).translate('verification_title'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerifyResetOtpSuccess) {
            _showNewPasswordDialog(state.otp);
          } else if (state is ResetPasswordSuccess) {
            // Close Dialog if open (it is)
            Navigator.of(context).pop(); // Pops the dialog

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.successColor,
              ),
            );
            // Navigate to Login
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          } else if (state is AuthError) {
            String errorMessage = state.message;
            final lower = state.message.toLowerCase();
            if (lower.contains('invalid otp')) {
              errorMessage = AppLocalizations.of(
                context,
              ).translate('error_invalid_otp');
            } else if (lower.contains('expired')) {
              errorMessage = AppLocalizations.of(
                context,
              ).translate('error_otp_expired');
            } else if (lower.contains('user not found')) {
              errorMessage = AppLocalizations.of(
                context,
              ).translate('error_user_not_found');
            } else if (lower.contains('too many failed attempts')) {
              errorMessage = AppLocalizations.of(
                context,
              ).translate('error_too_many_attempts');
            } else if (lower.contains('server')) {
              errorMessage = AppLocalizations.of(
                context,
              ).translate('error_server');
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: AppTheme.dangerColor,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    ).translate('reset_password_instruction'),
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  Pinput(
                    length: 6,
                    controller: _otpController,
                    onCompleted: (_) => _onVerifyOtp(),
                    defaultPinTheme: PinTheme(
                      width: 56,
                      height: 56,
                      textStyle: AppTheme.headingMedium,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _onVerifyOtp,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Verify'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _start == 0 ? _onResendOtp : null,
                    child: Text(
                      _start > 0
                          ? '${AppLocalizations.of(context).translate('resend')} ($_start s)'
                          : AppLocalizations.of(context).translate('resend'),
                      style: TextStyle(
                        color: _start > 0
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
