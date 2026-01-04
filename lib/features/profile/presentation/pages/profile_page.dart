import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import 'package:camera_v1/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark =
        context.watch<SettingsCubit>().state.themeMode == ThemeMode.dark;
    final currentLanguage =
        context.watch<SettingsCubit>().state.locale.languageCode == 'vi'
        ? 'Tiếng Việt'
        : 'English';
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.translate('change_password_success')),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String name = "John Doe";
          String email = "johndoe@example.com";

          if (state is AuthAuthenticated) {
            final user = state.user;
            // Clean name logic
            if (user.firstName.isNotEmpty || user.lastName.isNotEmpty) {
              name = '${user.firstName} ${user.lastName}'.trim();
            }
            email = user.email;
          }

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                loc.translate('profile_title'),
                style: AppTheme.headingMedium.copyWith(
                  color: theme.colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar Section
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.surface,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: theme.colorScheme.surface,
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.5),
                                ),
                                // backgroundImage: AssetImage('assets/images/user.png'), // Placeholder
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Free Plan Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.cloud_queue,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      loc.translate('free_plan'),
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    // Simplified description
                                  ],
                                ),
                              ],
                            ),
                            // Badge icon
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.star,
                                color: Colors.blue,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Upgrade to unlock 30-day cloud storage & AI detection features.",
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  loc.translate('upgrade_premium'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // General Settings
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      loc.translate('general_settings'),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSettingsTile(
                    context,
                    icon: Icons.notifications,
                    iconColor: Colors.orange,
                    title: loc.translate('notifications'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("On", style: theme.textTheme.bodySmall),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: theme.hintColor,
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.language,
                    iconColor: Colors.blue,
                    title: loc.translate('language'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentLanguage,
                          style: TextStyle(color: theme.hintColor),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: theme.hintColor,
                        ),
                      ],
                    ),
                    onTap: () => _showLanguageDialog(context),
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.dark_mode,
                    iconColor: Colors.purple,
                    title: loc.translate('dark_mode'),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (val) {
                        context.read<SettingsCubit>().toggleTheme(val);
                      },
                      activeColor: Colors.purple,
                    ),
                    onTap: null, // Switch handles it
                  ),

                  const SizedBox(height: 24),

                  // Support & Legal
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      loc.translate('support_legal'),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildSettingsTile(
                    context,
                    icon: Icons.help_outline,
                    iconColor: Colors.green,
                    title: loc.translate('help_center'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: theme.hintColor,
                    ),
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.lock_outline,
                    iconColor: Colors.grey,
                    title: loc.translate('privacy_policy'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: theme.hintColor,
                    ),
                    onTap: () {},
                  ),
                  _buildSettingsTile(
                    context,
                    icon: Icons.description_outlined,
                    iconColor: Colors.grey,
                    title: loc.translate('terms_of_service'),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: theme.hintColor,
                    ),
                    onTap: () {},
                  ),

                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(LogoutEvent());
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            backgroundColor: theme.colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child: Text(
                            loc.translate('log_out'),
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _showChangePasswordDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child: Text(
                            loc.translate('change_password'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Text(
                    "${loc.translate('app_version')} 2.1.0",
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final loc = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                loc.translate('language'),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('English (US)'),
                trailing:
                    context.read<SettingsCubit>().state.locale.languageCode ==
                        'en'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  context.read<SettingsCubit>().setLocale(
                    const Locale('en', 'US'),
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Tiếng Việt (VN)'),
                trailing:
                    context.read<SettingsCubit>().state.locale.languageCode ==
                        'vi'
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  context.read<SettingsCubit>().setLocale(
                    const Locale('vi', 'VN'),
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(loc.translate('change_password')),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: loc.translate('old_password'),
                    hintText: loc.translate('enter_old_password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.translate('enter_old_password');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: loc.translate('new_password_label'),
                    hintText: loc.translate('enter_new_password'),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return loc.translate('enter_new_password');
                    }
                    if (value.length < 6) {
                      return loc.translate('error_password_length');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: loc.translate('confirm_new_password'),
                    hintText: loc.translate('confirm_password_hint'),
                  ),
                  validator: (value) {
                    if (value != newPasswordController.text) {
                      return loc.translate('error_confirm_password_match');
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthBloc>().add(
                    ChangePasswordEvent(
                      oldPassword: oldPasswordController.text,
                      newPassword: newPasswordController.text,
                    ),
                  );
                  Navigator.pop(dialogContext);
                }
              },
              child: Text(loc.translate('change_password')),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}
