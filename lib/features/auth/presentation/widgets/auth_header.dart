import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final bool isTablet;

  const AuthHeader({super.key, required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon container with shield
        Container(
          width: isTablet ? 100 : 80,
          height: isTablet ? 100 : 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.shield_outlined,
            size: isTablet ? 50 : 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),

        SizedBox(height: isTablet ? 40 : 32),

        // Welcome text
        Text(
          AppLocalizations.of(context).translate('welcome'),
          style: AppTheme.headingLarge.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 40 : 32,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          AppLocalizations.of(context).translate('login_subtitle'),
          style: AppTheme.bodyMedium.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            fontSize: isTablet ? 16 : 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
