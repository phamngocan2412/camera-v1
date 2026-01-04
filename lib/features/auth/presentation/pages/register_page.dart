import 'package:camera_v1/config/routes/app_routes.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:camera_v1/core/utils/location_helper.dart';
import 'package:camera_v1/features/auth/presentation/bloc/bloc/auth_bloc.dart';
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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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

                // First Name field
                Text(
                  AppLocalizations.of(context).translate('first_name'),
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      context,
                    ).translate('first_name_hint'),
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                  textInputAction: TextInputAction.next,
                  style: AppTheme.bodyLarge,
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

                // Last Name field
                Text(
                  AppLocalizations.of(context).translate('last_name'),
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      context,
                    ).translate('last_name_hint'),
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                  textInputAction: TextInputAction.next,
                  style: AppTheme.bodyLarge,
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

                // Phone Number field with country code
                Text(
                  AppLocalizations.of(context).translate('phone_number'),
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                // Phone Number field with country code picker
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: '123456789',
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        flagWidth: 24,
                        textStyle: AppTheme.bodyLarge.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        dialogTextStyle: AppTheme.bodyMedium,
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
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  style: AppTheme.bodyLarge,
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

                // Email field
                Text(
                  AppLocalizations.of(context).translate('email'),
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
                    ).translate('email_hint'),
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
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
                  textInputAction: TextInputAction.next,
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
                ),

                const SizedBox(height: 20),

                // Confirm Password field
                Text(
                  AppLocalizations.of(context).translate('confirm_password'),
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      context,
                    ).translate('confirm_password_hint'),
                    hintStyle: AppTheme.bodyMedium.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.5),
                  ),
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  style: AppTheme.bodyLarge,
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

                // Terms and Privacy
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTheme.bodySmall.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(
                          context,
                        ).translate('terms_agree'),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to terms
                          },
                          child: Text(
                            AppLocalizations.of(
                              context,
                            ).translate('terms_of_service'),
                            style: AppTheme.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context).translate('and'),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to privacy
                          },
                          child: Text(
                            AppLocalizations.of(
                              context,
                            ).translate('privacy_policy'),
                            style: AppTheme.bodySmall.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
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

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // final fullPhoneNumber = '$_countryCode${_phoneController.text}';
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
