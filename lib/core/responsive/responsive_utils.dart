// lib/core/responsive/responsive_utils.dart

import 'package:flutter/widgets.dart';
import 'responsive_breakpoints.dart';

/// Enum describing the current screen size category.
enum ResponsiveScreenSize { compact, medium, expanded }

/// Helper to categorize the current screen width.
ResponsiveScreenSize getScreenSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < ResponsiveBreakpoints.compact) {
    return ResponsiveScreenSize.compact;
  } else if (width < ResponsiveBreakpoints.expanded) {
    return ResponsiveScreenSize.medium;
  } else {
    return ResponsiveScreenSize.expanded;
  }
}
