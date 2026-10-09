// lib/core/responsive/responsive_layout.dart

import 'package:flutter/widgets.dart';
import 'responsive_utils.dart';

/// A widget that applies responsive constraints and layout adaptations.
///
/// - For **compact** screens (<600dp) it returns the [child] unchanged.
/// - For **medium** screens (<1024dp) it adds horizontal padding to
///   improve readability.
/// - For **expanded** screens (>=1024dp) it centers the content in a
///   constrained box with a maximum width of 1200dp, providing a desktop‑
///   friendly layout.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;

  const ResponsiveLayout({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ResponsiveScreenSize.compact:
        // Mobile‑first: no extra constraints.
        return child;
      case ResponsiveScreenSize.medium:
        // Add modest horizontal padding to avoid edge‑to‑edge content.
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: child,
        );
      case ResponsiveScreenSize.expanded:
        // Desktop/web: constrain width and center.
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: child,
          ),
        );
    }
  }
}
