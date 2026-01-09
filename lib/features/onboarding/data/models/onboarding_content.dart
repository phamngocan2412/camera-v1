class OnboardingContent {
  final String image;
  final String title;
  final String description;

  const OnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

// Sample data - Replace with actual assets later
final List<OnboardingContent> onboardingContents = [
  OnboardingContent(
    image:
        "assets/images/onboarding1.png", // Ensure these assets exist or use placeholders
    title: "Welcome to Our App",
    description: "Discover amazing features and connect with people.",
  ),
  OnboardingContent(
    image: "assets/images/onboarding2.png",
    title: "Stay Organized",
    description: "Keep track of your tasks and projects effortlessly.",
  ),
  OnboardingContent(
    image: "assets/images/onboarding3.png",
    title: "Get Started Now",
    description: "Join our community and start your journey today.",
  ),
];
