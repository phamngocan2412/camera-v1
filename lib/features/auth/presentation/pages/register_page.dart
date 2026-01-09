import 'package:camera_v1/config/routes/app_routes.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:camera_v1/core/utils/location_helper.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:camera_v1/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:camera_v1/features/auth/presentation/widgets/terms_privacy_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _countryCode = '+84';
  // ignore: unused_field
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _requestLocationAndSetCountryCode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _requestLocationAndSetCountryCode() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final countryCode = await LocationHelper.getCountryCodeFromLocation();
      if (mounted) {
        setState(() {
          _countryCode = countryCode;
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _countryCode = LocationHelper.defaultCountryCode;
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${AppLocalizations.of(context).translate('welcome')}, ${state.user.firstName} ${state.user.lastName}',
                style: AppTheme.bodyMedium,
              ),
              backgroundColor: AppTheme.successColor,
            ),
          );
          // Navigate to home page
        } else if (state is VerificationRequired) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please verify your email'),
              backgroundColor: AppTheme.infoColor,
            ),
          );
          Navigator.pushNamed(
            context,
            AppRoutes.verification,
            arguments: state.email,
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
            vertical: 16.0,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: isTablet ? 40 : 32),

                // Title
                Text(
                  AppLocalizations.of(context).translate('create_account'),
                  style: AppTheme.headingLarge.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 40 : 32,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  AppLocalizations.of(context).translate('register_subtitle'),
                  style: AppTheme.bodyMedium.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                    fontSize: isTablet ? 16 : 14,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: isTablet ? 40 : 32),

                AuthTextField(
                  controller: _firstNameController,
                  label: AppLocalizations.of(context).translate('first_name'),
                  hintText: AppLocalizations.of(
                    context,
                  ).translate('first_name_hint'),
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_first_name');
                    }
                    if (value.length < 2) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_first_name_length');
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: _lastNameController,
                  label: AppLocalizations.of(context).translate('last_name'),
                  hintText: AppLocalizations.of(
                    context,
                  ).translate('last_name_hint'),
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_last_name');
                    }
                    if (value.length < 2) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_last_name_length');
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Phone with country picker
                AuthTextField(
                  controller: _phoneController,
                  label: AppLocalizations.of(context).translate('phone_number'),
                  hintText: '123456789',
                  keyboardType: TextInputType.phone,
                  prefixWidget: Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: CountryCodePicker(
                      onChanged: (country) {
                        setState(() {
                          _countryCode = country.dialCode ?? '+84';
                        });
                      },
                      initialSelection: _countryCode,
                      favorite: const ['+84', 'US'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                      dialogBackgroundColor:
                          Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      flagWidth: 24,
                      textStyle: AppTheme.bodyLarge.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      dialogTextStyle: AppTheme.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      searchDecoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        ).translate('search_country'),
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_phone');
                    }
                    final phoneRegex = RegExp(r'^[0-9]{8,15}$');
                    if (!phoneRegex.hasMatch(value)) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_phone_valid');
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: _emailController,
                  label: AppLocalizations.of(context).translate('email'),
                  hintText: AppLocalizations.of(
                    context,
                  ).translate('email_hint'),
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
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
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: _passwordController,
                  label: AppLocalizations.of(context).translate('password'),
                  hintText: AppLocalizations.of(
                    context,
                  ).translate('password_hint'),
                  prefixIcon: Icons.lock_outlined,
                  isPassword: true,
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
                ),

                const SizedBox(height: 20),

                AuthTextField(
                  controller: _confirmPasswordController,
                  label: AppLocalizations.of(
                    context,
                  ).translate('confirm_password'),
                  hintText: AppLocalizations.of(
                    context,
                  ).translate('confirm_password_hint'),
                  prefixIcon: Icons.lock_outlined,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_confirm_password');
                    }
                    if (value != _passwordController.text) {
                      return AppLocalizations.of(
                        context,
                      ).translate('error_password_match');
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleRegister(),
                ),

                const SizedBox(height: 24),

                // Sign Up button
                ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppLocalizations.of(context).translate('sign_up_btn'),
                    style: AppTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const TermsAndPrivacyText(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        RegisterEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          countryCode: _countryCode,
        ),
      );
    }
  }
}
