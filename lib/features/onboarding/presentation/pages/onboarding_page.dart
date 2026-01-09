import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../config/routes/app_routes.dart';
import '../../data/models/onboarding_content.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToNextPage();
      }
    });

    // Start animation for the first page
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _progressController.forward(from: 0.0);
  }

  void _goToNextPage() {
    if (_currentIndex < onboardingContents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Reset and restart animation for the new page
    _progressController.reset();
    _progressController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onLongPressDown: (_) {
            // Pause animation on long press
            if (_progressController.isAnimating) {
              _progressController.stop();
            }
          },
          onLongPressEnd: (_) {
            // Resume animation on release
            if (_progressController.status != AnimationStatus.completed) {
              _progressController.forward();
            }
          },
          onLongPressCancel: () {
            if (_progressController.status != AnimationStatus.completed) {
              _progressController.forward();
            }
          },
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: onboardingContents.length,
                  itemBuilder: (context, index) {
                    final content = onboardingContents[index];
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Spacer(),
                          // Replace with Image.asset when assets are available
                          // Image.asset(content.image, height: 250),
                          Container(
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            content.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            content.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: Colors.grey.shade600),
                          ),
                          Spacer(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button (Hidden on first page)
                    if (_currentIndex > 0)
                      GestureDetector(
                        onTap: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 48), // Spacer to keep layout
                    // Indicators
                    Row(
                      children: List.generate(
                        onboardingContents.length,
                        (index) => OnboardingIndicator(
                          isActive: index == _currentIndex,
                          controller: _progressController,
                        ),
                      ),
                    ),

                    // Next Button
                    GestureDetector(
                      onTap: _goToNextPage,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF2B2B2E),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
