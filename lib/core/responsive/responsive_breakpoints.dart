// lib/core/responsive/responsive_breakpoints.dart

/// Breakpoint widths (in logical pixels) used throughout the app.
/// These values are inspired by Material Design guidelines but tuned
/// for the cosmic visual style.
class ResponsiveBreakpoints {
  // Mobile phones (portrait & small landscape)
  static const double compact = 600; // < 600dp

  // Tablets – medium screens
  static const double medium = 1024; // >= 600dp && < 1024dp

  // Expanded – desktop / large tablet landscape / web
  static const double expanded = 1440; // >= 1024dp
}
