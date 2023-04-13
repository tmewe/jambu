import 'package:flutter/material.dart';

class OnboardingContainer extends StatelessWidget {
  const OnboardingContainer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox.expand(
            child: child,
          ),
        ),
      ),
    );
  }
}
