import 'package:camera_v1/core/presentation/widgets/animated_background.dart';
import 'package:camera_v1/core/presentation/widgets/fade_slide_transition.dart';
import 'package:camera_v1/core/theme/app_theme.dart';
import 'package:camera_v1/core/l10n/app_localizations.dart';
import 'package:camera_v1/features/auth/presentation/pages/register_page.dart';
import 'package:camera_v1/features/auth/presentation/widgets/auth_header.dart';
import 'package:camera_v1/features/auth/presentation/widgets/auth_tab_selector.dart';
import 'package:camera_v1/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:camera_v1/core/utils/location_helper.dart';

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
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    // This will trigger permission request if not granted
    await LocationHelper.getCountryCodeFromLocation();
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
      body: AnimatedBackground(
        child: SafeArea(
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
                          FadeSlideTransition(
                            delay: const Duration(milliseconds: 100),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                onPressed: () {
                                  // Navigate to help page
                                },
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  ).translate('help'),
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          FadeSlideTransition(
                            delay: const Duration(milliseconds: 200),
                            child: AuthHeader(isTablet: isTablet),
                          ),

                          SizedBox(height: isTablet ? 40 : 32),

                          FadeSlideTransition(
                            delay: const Duration(milliseconds: 300),
                            child: AuthTabSelector(
                              tabController: _tabController,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Tab content with fixed height
                          FadeSlideTransition(
                            delay: const Duration(milliseconds: 400),
                            child: SizedBox(
                              height: isTablet ? 600 : 500,
                              child: TabBarView(
                                controller: _tabController,
                                children: const [LoginForm(), RegisterPage()],
                              ),
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
      ),
    );
  }
}
