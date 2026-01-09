import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTheme.bodySmall.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        children: [
          TextSpan(
            text: AppLocalizations.of(context).translate('terms_agree'),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                // Navigate to terms
              },
              child: Text(
                AppLocalizations.of(context).translate('terms_of_service'),
                style: AppTheme.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          TextSpan(text: AppLocalizations.of(context).translate('and')),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                // Navigate to privacy
              },
              child: Text(
                AppLocalizations.of(context).translate('privacy_policy'),
                style: AppTheme.bodySmall.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
