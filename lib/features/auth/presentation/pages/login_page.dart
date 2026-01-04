import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:camera_v1/features/auth/presentation/pages/register_page.dart';
import 'package:camera_v1/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isTablet ? 64.0 : 32.0;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = isTablet ? 500.0 : double.infinity;
            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth,
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Help link in top-right
                        Align(
                          alignment: Alignment.topRight,
                          child: TextButton(
                            onPressed: () {
                              // Navigate to help page
                            },
                            child: Text(
                              AppLocalizations.of(context).translate('help'),
                              style: AppTheme.bodyMedium.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Icon container with shield
                        Container(
                          width: isTablet ? 100 : 80,
                          height: isTablet ? 100 : 80,
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
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
                          AppLocalizations.of(
                            context,
                          ).translate('login_subtitle'),
                          style: AppTheme.bodyMedium.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                            fontSize: isTablet ? 16 : 14,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: isTablet ? 40 : 32),

                        // Tab selector
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            labelColor: Theme.of(context).colorScheme.onPrimary,
                            unselectedLabelColor: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.6),
                            labelStyle: AppTheme.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            unselectedLabelStyle: AppTheme.bodyLarge,
                            tabs: [
                              Tab(
                                text: AppLocalizations.of(
                                  context,
                                ).translate('login_tab'),
                              ),
                              Tab(
                                text: AppLocalizations.of(
                                  context,
                                ).translate('signup_tab'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Tab content with fixed height
                        SizedBox(
                          height: isTablet ? 600 : 500,
                          child: TabBarView(
                            controller: _tabController,
                            children: const [LoginForm(), RegisterPage()],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
