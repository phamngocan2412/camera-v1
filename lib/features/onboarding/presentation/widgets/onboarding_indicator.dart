import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.isActive,
    required this.controller,
  });

  final bool isActive;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8, // Expanded width for active
      decoration: BoxDecoration(
        color: isActive ? Colors.grey.shade300 : Colors.grey.shade400,
        borderRadius: BorderRadius.circular(4),
      ),
      child: isActive
          ? AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: controller.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B2B2E), // Active Fill Color
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
