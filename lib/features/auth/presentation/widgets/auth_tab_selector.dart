import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AuthTabSelector extends StatelessWidget {
  final TabController tabController;

  const AuthTabSelector({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Theme.of(context).colorScheme.onPrimary,
        unselectedLabelColor:
            Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        labelStyle: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTheme.bodyLarge,
        tabs: [
          Tab(text: AppLocalizations.of(context).translate('login_tab')),
          Tab(text: AppLocalizations.of(context).translate('signup_tab')),
        ],
      ),
    );
  }
}
